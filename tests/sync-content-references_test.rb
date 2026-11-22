require "fileutils"
require "minitest/autorun"
require "open3"
require "rbconfig"
require "tmpdir"
require "yaml"

class SyncContentReferencesTest < Minitest::Test
  SCRIPT = File.expand_path("../scripts/sync-content-references.rb", __dir__)
  VOLUME = "content/volumes/sport.md"
  FIRST_CHAPTER = "content/chapters/first.md"
  SECOND_CHAPTER = "content/chapters/second.md"
  FIRST_CARD = "content/cards/first.md"
  SECOND_CARD = "content/cards/second.md"

  def setup
    @directory = Dir.mktmpdir
    run_git("init", "-q")
    run_git("config", "user.name", "Test")
    run_git("config", "user.email", "test@example.com")
    write_page(VOLUME, "title" => "Sport", "chapters" => [FIRST_CHAPTER])
    write_page(
      FIRST_CHAPTER,
      "title" => "First",
      "volume" => VOLUME,
      "cards" => [FIRST_CARD]
    )
    write_page(FIRST_CARD, "title" => "First card", "chapter" => FIRST_CHAPTER)
    commit
  end

  def teardown
    FileUtils.remove_entry(@directory)
  end

  def test_new_card_is_added_at_top_and_siblings_are_reordered
    write_page(SECOND_CARD, "title" => "Second card", "chapter" => FIRST_CHAPTER)
    commit

    run_sync

    chapter = read_page(FIRST_CHAPTER)
    assert_equal [SECOND_CARD, FIRST_CARD], chapter["cards"]
    assert_equal 1, read_page(SECOND_CARD)["order"]
    assert_equal 2, read_page(FIRST_CARD)["order"]
  end

  def test_deleted_card_is_removed_and_siblings_are_reordered
    write_page(
      FIRST_CHAPTER,
      "title" => "First",
      "volume" => VOLUME,
      "cards" => [SECOND_CARD, FIRST_CARD]
    )
    write_page(SECOND_CARD, "title" => "Second card", "chapter" => FIRST_CHAPTER, "order" => 1)
    write_page(FIRST_CARD, "title" => "First card", "chapter" => FIRST_CHAPTER, "order" => 2)
    commit
    File.delete(File.join(@directory, SECOND_CARD))
    commit

    run_sync

    assert_equal [FIRST_CARD], read_page(FIRST_CHAPTER)["cards"]
    assert_equal 1, read_page(FIRST_CARD)["order"]
  end

  def test_new_chapter_is_added_at_top_and_deleted_chapter_is_removed
    write_page(SECOND_CHAPTER, "title" => "Second", "volume" => VOLUME)
    commit

    run_sync

    assert_equal [SECOND_CHAPTER, FIRST_CHAPTER], read_page(VOLUME)["chapters"]
    assert_equal 1, read_page(SECOND_CHAPTER)["order"]
    assert_equal 2, read_page(FIRST_CHAPTER)["order"]

    File.delete(File.join(@directory, SECOND_CHAPTER))
    commit
    run_sync

    assert_equal [FIRST_CHAPTER], read_page(VOLUME)["chapters"]
    assert_equal 1, read_page(FIRST_CHAPTER)["order"]
  end

  def test_parent_reordering_updates_display_order
    write_page(SECOND_CHAPTER, "title" => "Second", "volume" => VOLUME, "order" => 2)
    write_page(
      VOLUME,
      "title" => "Sport",
      "chapters" => [FIRST_CHAPTER, SECOND_CHAPTER]
    )
    commit
    write_page(
      VOLUME,
      "title" => "Sport",
      "chapters" => [SECOND_CHAPTER, FIRST_CHAPTER]
    )
    commit

    run_sync

    assert_equal 1, read_page(SECOND_CHAPTER)["order"]
    assert_equal 2, read_page(FIRST_CHAPTER)["order"]
  end

  private

  def write_page(path, data)
    full_path = File.join(@directory, path)
    FileUtils.mkdir_p(File.dirname(full_path))
    File.write(full_path, "#{YAML.dump(data)}---\n")
  end

  def read_page(path)
    text = File.read(File.join(@directory, path))
    YAML.safe_load(text.sub(/\A---\n/, "").sub(/\n---\n\z/, ""), aliases: true)
  end

  def commit
    run_git("add", "-A")
    run_git("commit", "-m", "fixture")
  end

  def run_sync
    output, status = Open3.capture2e(RbConfig.ruby, SCRIPT, chdir: @directory)
    assert status.success?, output
  end

  def run_git(*arguments)
    output, status = Open3.capture2e("git", *arguments, chdir: @directory)
    assert status.success?, output
  end
end
