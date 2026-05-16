# Hugo + PagesCMS Portfolio Site

A modern portfolio and blog site built with Hugo static site generator and PagesCMS for content management.

## Overview

This project combines:
- **Hugo** - Fast static site generator
- **PagesCMS** - Git-based headless CMS for content editing
- **PaperMod Theme** - Clean, responsive Hugo theme
- **Git-native workflow** - All content stored in version control

## Features

- 📝 Multiple content types: Projects, Posts, Pages, About
- 🎨 Responsive design powered by PaperMod theme
- ⚡ Fast static site generation
- 📋 Easy content management through PagesCMS
- 🔧 Simple development workflow
- 📱 Mobile-friendly portfolio

## Project Structure

```
luka-nz/
├── content/                 # Site content (managed by PagesCMS)
│   ├── projects/           # Portfolio projects
│   ├── posts/              # Blog posts
│   ├── pages/              # Static pages
│   └── about/              # About section
├── layouts/                # Custom Hugo templates (optional)
├── static/                 # Static assets
│   ├── uploads/            # Media uploads
│   └── images/             # Images and graphics
├── themes/
│   └── PaperMod/          # Hugo theme
├── hugo.toml              # Hugo configuration
├── pagescms.config.json   # PagesCMS configuration
├── package.json           # Project metadata and scripts
├── .env.example           # Environment variables template
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
4. Configure GitHub OAuth if required
5. Copy environment variables to `.env` file:

```bash
cp .env.example .env
# Edit .env with your credentials
```

## Content Management

### File-Based (Direct)

Edit markdown files directly:

```bash
# Create a new post
nano content/posts/my-post.md

# Create a new project
nano content/projects/my-project.md
```

### PagesCMS UI

1. Log in to PagesCMS dashboard
2. Navigate to Collections (Projects, Posts, Pages, About)
3. Click "New" to create content
4. Fill in fields and publish
5. Changes automatically commit to Git

## Development

### Local Development Server

```bash
# Start Hugo dev server with live reload
npm run dev
# or
hugo server -D

# Visit http://localhost:1313
```

The `-D` flag shows draft posts. Remove it in production builds.

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

### Projects

Portfolio entries with technology stack and links.

**File location**: `content/projects/`

**Fields**:
- Title (required)
- Description
- Project Image
- Project Link
- Technologies (list)
- Draft status

**Example**: `content/projects/sample-project-one.md`

### Posts

Blog articles with categories and tags.

**File location**: `content/posts/`

**Fields**:
- Title (required)
- Publish Date
- Categories (list)
- Tags (list)
- Draft status
- Content (markdown)

**Example**: `content/posts/getting-started-with-hugo.md`

### Pages

Static pages (home, etc.)

**File location**: `content/pages/`

**Fields**:
- Title (required)
- Draft status
- Content (markdown)

### About

About section.

**File location**: `content/about/`

**Fields**:
- Title (required)
- Draft status
- Content (markdown)

## Configuration

### Hugo Configuration

Edit `hugo.toml` to customize:

```toml
baseURL = "https://yourdomain.com/"
title = "Your Portfolio"
theme = "PaperMod"

# Add menu items
menu:
  main:
    - name: Home
      url: /
    - name: Projects
      url: /projects/
    # Add more menu items
```

### PagesCMS Configuration

Edit `pagescms.config.json` to:
- Add/modify content collections
- Change field types
- Configure media settings
- Adjust upload directories

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

Posts and Projects use TOML front matter:

```toml
---
title = "Post Title"
date = 2024-01-10T08:00:00Z
categories = ["Category"]
tags = ["tag1", "tag2"]
draft = false
---
```

### Draft vs Published

- `draft = true` - Content hidden from production (visible with `-D` flag in dev)
- `draft = false` - Content published and visible

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

Add styles to `static/css/` and reference in layouts.

### Static Assets

Place images, fonts, and other files in `static/` directory.

## Troubleshooting

### Hugo not found

Install Hugo: https://gohugo.io/installation/

### Theme not showing

```bash
# Ensure theme is correctly referenced
cat hugo.toml | grep theme

# Verify theme exists
ls -la themes/PaperMod
```

### Content not appearing

- Check draft status: `draft = false`
- Verify file format: Must be `.md` in correct folder
- Check front matter syntax (TOML or YAML)

### PagesCMS not syncing

- Verify GitHub OAuth credentials in `.env`
- Check repository permissions
- Ensure content folders exist in Git

## Environment Variables

Required for PagesCMS integration:

```
GITHUB_CLIENT_ID         - GitHub OAuth app client ID
GITHUB_CLIENT_SECRET     - GitHub OAuth app client secret
GITHUB_REPO_OWNER        - GitHub username
GITHUB_REPO_NAME         - Repository name
PAGES_CMS_BRANCH         - Git branch to manage (default: main)
```

Get OAuth credentials at: https://github.com/settings/developers

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
