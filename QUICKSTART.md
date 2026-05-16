# Quick Start Guide

## Project Successfully Created! 🎉

Your Hugo + PagesCMS portfolio site has been initialized at:
```
/Users/eric/Projects/luka-nz
```

## What's Included

✅ **Hugo Project Structure**
- Content folders: projects, posts, pages, about
- PaperMod theme (responsive, modern design)
- Sample content to get you started

✅ **PagesCMS Integration**
- Configuration file: `pagescms.config.json`
- Multi-collection setup ready
- Media upload directory configured

✅ **Development Ready**
- Package.json with npm scripts
- Environment template (.env.example)
- Git repository initialized

## Next Steps

### 1. Install Hugo on Your System
```bash
# macOS with Homebrew
brew install hugo

# Verify installation
hugo version
```

Hugo must be version 0.135.0 or higher.
https://gohugo.io/installation/

### 2. Test the Local Development Server
```bash
cd /Users/eric/Projects/luka-nz

# Start development server
npm run dev
# or
hugo server -D

# Visit http://localhost:1313
```

You should see:
- Navigation menu with Home, Projects, Posts, About
- Sample project entries
- Sample blog post
- About section

### 3. Set Up PagesCMS

Visit https://pagescms.org and:

1. Create a new project
2. Connect to your GitHub repository:
   - Repository: `ericwillems/luka-nz` (or your fork)
   - Configure GitHub OAuth
3. Copy credentials to `.env`:
   ```bash
   cp .env.example .env
   # Edit .env with your GitHub OAuth credentials
   ```

### 4. Start Creating Content

**Option A: Using PagesCMS UI**
- Log in to https://pagescms.org
- Use Collections to create/edit content
- Changes auto-commit to Git

**Option B: Direct File Editing**
- Edit markdown files in `content/` directories
- Add to git, commit, and push

## Project Structure

```
luka-nz/
├── content/              # Your content (managed by PagesCMS)
│   ├── projects/        # Portfolio projects
│   ├── posts/           # Blog articles
│   ├── pages/           # Static pages
│   └── about/           # About section
├── static/              # Static assets
│   └── uploads/         # Media uploads
├── themes/
│   └── PaperMod/        # Hugo theme
├── hugo.toml            # Hugo configuration
├── pagescms.config.json # PagesCMS configuration
└── README.md            # Full documentation
```

## Important Files

- **hugo.toml** - Configure site title, theme, menu, etc.
- **pagescms.config.json** - Define content collections and fields
- **.env** - Store GitHub credentials (create from .env.example)
- **README.md** - Complete documentation

## Customization

### Change Site Title and URL
Edit `hugo.toml`:
```toml
baseURL = "https://yourdomain.com/"
title = "Your Portfolio"
```

### Update Navigation Menu
Edit `hugo.toml` menu section:
```toml
menu:
  main:
    - name: Home
      url: /
      weight: 1
    # Add more items
```

### Add New Content Collection
Edit `pagescms.config.json` to add new collections with custom fields.

## Key Commands

```bash
# Development (with live reload)
npm run dev

# Production build
npm run build:prod

# Clean build
npm run clean

# See sample content
cat content/posts/getting-started-with-hugo.md
cat content/projects/sample-project-one.md
```

## GitHub Integration

Set up GitHub OAuth for PagesCMS:
https://github.com/settings/developers

1. Create OAuth App
2. Copy Client ID and Secret
3. Add to `.env` file
4. Push changes to GitHub
5. Connect repository in PagesCMS

## Need Help?

- **Hugo Documentation**: https://gohugo.io/documentation/
- **PaperMod Theme**: https://github.com/adityatelange/hugo-PaperMod
- **PagesCMS Documentation**: https://pagescms.org/docs
- **Full README**: See README.md in project root

## Deployment Options

- **Netlify**: Auto-deploy from Git
- **Vercel**: Auto-deploy from Git
- **GitHub Pages**: Manual or Actions workflow
- **Any static host**: Build with `hugo --minify`, deploy `public/` folder

---

**You're all set! 🚀 Start with:** `npm run dev` to see your site in action.
