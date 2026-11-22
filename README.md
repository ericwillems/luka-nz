# Luka.nz — Hugo + PagesCMS

A Hugo site for Luka.nz, with Volumes, Chapters, and Cards managed through PagesCMS.

## Overview

This project combines:
- **Hugo** - Fast static site generator
- **PagesCMS** - Git-based headless CMS for content editing
- **PaperMod Theme** - Clean, responsive Hugo theme
- **Git-native workflow** - All content stored in version control

## Features

- 📝 Home, Volumes, Chapters, and Cards content types
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
│   ├── volumes/            # Top-level volume pages
│   ├── chapters/           # Chapters assigned to volumes
│   └── cards/              # Cards assigned to chapters
├── assets/images/          # Images and PagesCMS uploads
├── layouts/                # Volume/chapter/card templates and image layouts
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
4. The `.pages.yml` file in the repository root defines the Volumes, Chapters, Cards, and Home Page collections.

## Content Management

### File-Based (Direct)

Edit markdown files directly:

```bash
# Create a chapter page
nano content/chapters/my-chapter.md

# Create a card assigned to a chapter
nano content/cards/my-card.md
```

### PagesCMS UI

1. Log in to the PagesCMS dashboard.
2. Use **Volumes** for top-level navigation entries. Each volume can have a banner and an ordered list of chapters.
3. Use **Chapters** to add chapter content, select its volume, and set the ordered cards to display.
4. Use **Cards** to add content to a chapter. Cards have a title, body, optional title hiding, and an ordered list of images with optional captions.
5. Publish the change; PagesCMS commits it to Git.

## Development

### Local Development Server

```bash
# Start Hugo dev server with live reload
npm run dev
# or
hugo server -D --baseURL http://localhost:1313/

# Visit http://localhost:1313/
```

The `-D` flag shows draft volumes, chapters, and cards. Remove it in production builds.

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

### Home Page

The homepage is `content/_index.md` and is editable as the **Home Page** file in PagesCMS.

### Volumes

Volumes live in `content/volumes/` and represent top-level navigation. Each volume can have a banner, navigation weight, and an ordered list of chapters. Volume pages render chapter navigation as anchor links to each chapter further down the page.

### Chapters

Chapters live in `content/chapters/`. Each chapter belongs to one volume via the `volume` field and has an ordered `cards` reference list. The optional `card_limit` controls how many cards appear on its volume and standalone chapter pages. A volume's `chapters` list determines which chapters appear and in what order.

### Cards

Cards live in `content/cards/` and use a `chapter` reference to associate them with a chapter. Add each card to that chapter's `cards` list as well; the list determines inclusion and display order. Use the card body for prose and the `images` list for images with optional captions. Cards with zero or one image use a one-third-width column; cards with multiple images use a full-width horizontal image strip followed by the title and body. Set `hide_title: true` to omit a card's title from its display.

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

Cards use YAML front matter and an ordered list of image objects:

```yaml
---
title: "Card title"
chapter: content/chapters/sport.md
draft: false
hide_title: false
images:
  - image: images/sport/example.jpg
    caption: "Optional caption"
---
Card body text goes here.
```

Cards do not need a date. The chapter's ordered card references control their position.

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
