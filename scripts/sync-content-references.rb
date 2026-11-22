#!/usr/bin/env ruby

require "date"
require "open3"
require "set"
require "yaml"

Document = Struct.new(:path, :data, :original_data, :body, :frontmatter_yaml)

class OrderedContentSync
  def run
    volumes = load_collection("content/volumes")
    chapters = load_collection("content/chapters")
    cards = load_collection("content/cards")

    sync_collection(volumes, chapters, "chapters", "volume")
    sync_collection(chapters, cards, "cards", "chapter")

    updated = (volumes + chapters + cards).select do |document|
      document.data != document.original_data || needs_formatting?(document)
    end
    updated.each { |document| write_document(document) }
    puts "Synchronized ordered references; updated #{updated.length} files."
  end

  private

  def load_collection(directory)
    Dir.glob(File.join(directory, "*.md"))
      .reject { |path| File.basename(path) == "_index.md" }
      .map { |path| read_document(path) }
  end

  def read_document(path)
    text = File.read(path)
    match = text.match(/\A---[ \t]*\r?\n(.*?)\r?\n---[ \t]*\r?\n?(.*)\z/m)
    raise "Missing YAML front matter in #{path}" unless match

    data = YAML.safe_load(match[1], permitted_classes: [Date, Time], aliases: true) || {}
    raise "Expected YAML mapping in #{path}" unless data.is_a?(Hash)

    Document.new(path, data, data.dup, match[2], match[1])
  end

  def needs_formatting?(document)
    document.frontmatter_yaml.end_with?("\n") || document.body.start_with?("\n")
  end

  def sync_collection(parents, children, list_field, parent_field)
    parent_by_path = parents.to_h { |parent| [parent.path, parent] }
    children_by_path = children.to_h { |child| [child.path, child] }
    assigned = children.group_by { |child| child.data[parent_field].to_s }

    parents.each do |parent|
      current = Array(parent.data[list_field]).map(&:to_s)
      children_for_parent = assigned.fetch(parent.path, [])
      valid_paths = children_for_parent.map(&:path).to_set

      retained = current.uniq.select { |path| valid_paths.include?(path) }
      missing = children_for_parent.reject { |child| retained.include?(child.path) }
      missing.sort_by! { |child| [-last_changed_at(child.path), child.path] }

      ordered_paths = missing.map(&:path) + retained
      parent.data[list_field] = ordered_paths unless ordered_paths == current

      ordered_paths.each_with_index do |path, index|
        children_by_path.fetch(path).data["order"] = index + 1
      end
    end

    children.each do |child|
      next if parent_by_path.key?(child.data[parent_field].to_s)

      child.data.delete("order")
    end
  end

  def last_changed_at(path)
    output, status = Open3.capture2("git", "log", "-1", "--format=%ct", "--", path)
    status.success? ? output.to_i : 0
  end

  def write_document(document)
    yaml = YAML.dump(document.data, line_width: -1)
      .sub(/\A---\s*\n/, "")
      .sub(/\n\.\.\.\s*\z/, "")
      .sub(/\n+\z/, "")
      .gsub(/^(- )/, "  \\1")
    body = document.body.sub(/\A\r?\n/, "")
    File.write(document.path, "---\n#{yaml}\n---\n#{body}")
  end
end

OrderedContentSync.new.run
