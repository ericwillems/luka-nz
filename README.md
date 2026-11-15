# Luka.nz — Hugo + PagesCMS

A Hugo site for Luka.nz, with topic pages and topic-linked posts managed through PagesCMS.

## Overview

This project combines:
- **Hugo** - Fast static site generator
- **PagesCMS** - Git-based headless CMS for content editing
- **PaperMod Theme** - Clean, responsive Hugo theme
- **Git-native workflow** - All content stored in version control

## Features

- 📝 Five main topics with one-level sub-topics and topic posts
- 🎨 Responsive design powered by PaperMod theme
- ⚡ Fast static site generation
- 📋 Easy content management through PagesCMS
- 🔧 Simple development workflow
- 📱 Mobile-friendly portfolio

## Project Structure

```
luka-nz/
├── content/
│   ├── _index.md           # Home page
│   ├── topics/             # Topic landing pages
│   └── posts/              # Posts assigned to topics
├── assets/images/          # Images and PagesCMS uploads
├── layouts/                # Topic/post templates and image layouts
├── static/js/              # Image grouping behavior
├── .pages.yml              # PagesCMS collections and fields
├── themes/
│   └── PaperMod/          # Hugo theme
├── hugo.yaml              # Hugo configuration
├── package.json           # Project metadata and scripts
└── .gitignore             # Git ignore patterns
```

## Prerequisites

- **Hugo** (>= 0.135.0) - Install from https://gohugo.io/installation/
- **Node.js** (>= 18.0.0) - Optional, used for npm scripts
- **Git** - For version control
- **GitHub account** - Required for PagesCMS setup

## Installation

### 1. Local Development Setup

```bash
# Clone the repository (if using git)
git clone <repository-url>
cd luka-nz

# Install Hugo (macOS with Homebrew)
brew install hugo

# Verify installation
hugo version
```

### 2. PagesCMS Setup

1. Go to https://pagescms.org
2. Create a new project and connect your GitHub repository
3. Follow PagesCMS authentication flow
4. The `.pages.yml` file in the repository root defines the Topics, Topic Posts, and Home Page collections.

## Content Management

### File-Based (Direct)

Edit markdown files directly:

```bash
# Create a topic landing page
nano content/topics/my-topic.md

# Create a post assigned to a topic
nano content/posts/my-post.md
```

### PagesCMS UI

1. Log in to the PagesCMS dashboard.
2. Use **Topics** to edit a topic or choose a top-level parent for a sub-topic. Leave Parent Topic blank for one of the five top-level topics: Sport, Inclusion, Interests, Media, or Travel. Topics may only be one level deep.
3. Use **Topic Posts** to add content to a topic. A post title is optional.
4. Add ordered text and image blocks. Use one caption field for an image's caption and description; consecutive images without a caption display in a compact horizontal gallery.
5. Publish the change; PagesCMS commits it to Git.

## Development

### Local Development Server

```bash
# Start Hugo dev server with live reload
npm run dev
# or
hugo server -D

# Visit http://localhost:1313
```

The `-D` flag shows draft topics and posts. Remove it in production builds.

### Building

```bash
# Production build (optimized)
npm run build:prod
# or
hugo --minify

# Development build
npm run build
# or
hugo
```

Output is generated in `public/` directory.

### Clean Build

```bash
npm run clean
# or
rm -rf public/
```

## Content Types

### Topics

The **Life with Luka** index groups content under five main topics. The five top-level topic pages live in `content/topics/`, along with their sub-topics. A sub-topic's `parent` field references a top-level topic; nested sub-topics are rejected at build time. The Topics index lists only the five top-level topics. PagesCMS saves uploaded images under `assets/images/` and writes references using the public `images/` path. Hidden topics and posts remain drafts until they contain publishable content.

### Topic Posts

Posts live in `content/posts/` and use a `topic` reference to associate them with a topic page. Use the post body for prose and ordered content blocks to interleave text and images. Image blocks support a single caption/description field; images are emitted without alt text.

### Home

The homepage is `content/_index.md` and is editable as the **Home Page** file in PagesCMS.

## Configuration

### Hugo Configuration

Edit `hugo.yaml` to customize:

```yaml
baseURL: "https://yourdomain.com/"
title: "Your Site"
theme: "PaperMod"

menu:
  main:
    - name: Home
      url: /
      weight: 1
    - name: YouTube
      url: https://www.youtube.com/c/LukaWillems
      weight: 9
```

### PagesCMS Configuration

Edit `.pages.yml` to:
- Add/modify content collections
- Change field types
- Configure media settings
- Adjust the upload directory

## Deployment

### Netlify

1. Connect GitHub repository to Netlify
2. Set Hugo version: `0.135.0` (or compatible version)
3. Build command: `hugo --minify`
4. Publish directory: `public`

### Vercel

1. Import GitHub repository
2. Set environment variables from `.env`
3. Build command: `hugo --minify`
4. Output directory: `public`

### GitHub Pages

1. Set up `gh-pages` branch
2. Configure build in Actions or use deployment action
3. Build and deploy from `public/` directory

## Content Workflow

### Creating New Content

**With PagesCMS UI**:
1. Log in to PagesCMS
2. Select collection type
3. Click "New"
4. Fill in content
5. Publish (auto-commits)

**With Git (Direct)**:
1. Create markdown file in appropriate folder
2. Add front matter (YAML)
3. Write content
4. Save and commit

### Front Matter Format

Topic posts use YAML front matter and ordered content blocks:

```yaml
---
title: "Post title"
topic: topics/sport.md
date: 2026-01-10
draft: false
blocks:
  - text: "Text that appears before the image."
  - image: images/sport/example.jpg
    alt: "Description of the image"
    caption: "Optional caption"
---
```

Use text blocks for prose and image blocks for photos. The optional caption field can include both an image caption and description; adjacent images without a caption display in a compact gallery, while captioned images display in columns.

### Draft vs Published

- `draft: true` - Content hidden from production (visible with `-D` flag in dev)
- `draft: false` - Content published and visible

## Updating Theme

The PaperMod theme is a Git submodule. To update:

```bash
cd themes/PaperMod
git pull origin master
cd ../..

# Commit the theme update
git add themes/PaperMod
git commit -m "Update PaperMod theme"
```

## Customization

### Custom Layouts

Override theme templates by creating files in `layouts/`:

```
layouts/
├── _default/
│   ├── single.html
│   └── list.html
├── partials/
│   └── custom-header.html
```

### Custom CSS

Add styles to `assets/css/extended/` and reference them in layouts.

### Static Assets

Place images, fonts, and other files in `static/` directory.

## Troubleshooting

### Hugo not found

Install Hugo: https://gohugo.io/installation/

### Theme not showing

```bash
# Ensure theme is correctly referenced
cat hugo.yaml | grep theme

# Verify theme exists
ls -la themes/PaperMod
```

### Content not appearing

- Check draft status: `draft: false`
- Verify file format: Must be `.md` in correct folder
- Check front matter syntax (TOML or YAML)

### PagesCMS not syncing

- Check PagesCMS authorization and repository permissions.
- Confirm collection paths and fields in `.pages.yml`.
- Ensure content folders exist in Git.

## Resources

- [Hugo Documentation](https://gohugo.io/documentation/)
- [PaperMod Theme](https://github.com/adityatelange/hugo-PaperMod)
- [PagesCMS Docs](https://pagescms.org/docs)
- [Markdown Guide](https://www.markdownguide.org/)

## License

MIT

## Support

For issues or questions:
1. Check the [Hugo docs](https://gohugo.io/documentation/)
2. Review [PagesCMS documentation](https://pagescms.org/docs)
3. Check theme documentation: https://github.com/adityatelange/hugo-PaperMod

---

**Next Steps**:
1. Install Hugo locally
2. Run `npm run dev` to start development server
3. Set up PagesCMS at https://pagescms.org
4. Start creating content!
