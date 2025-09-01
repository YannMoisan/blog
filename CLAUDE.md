# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Development
- `bundle exec jekyll serve` - Builds and serves the site locally with live reload
- `bundle update jekyll` - Update Jekyll to latest version
- `./deploy.sh` - Deploy to production (uses rsync to server)
- `./check.sh` - Run content checks (typography fixes, missing punctuation)

### Content Management
- Blog posts go in `_posts/` with format `YYYY-MM-DD-title.md`
- News articles go in `_news/` with format `YYYY-MM-DD-news-from-last-month-YYYY-MM.md`
- Both use Jekyll front matter with `title`, `description`, `layout: post`, and optionally `lang: en`

## Architecture

This is a Jekyll-powered personal blog using the Minima theme, focused on Scala, Java, and Linux content.

### Site Structure
- `_posts/` - Main blog articles (dating back to 2011, primarily about Scala/Java development)
- `_news/` - Monthly "news from last month" curated link collections
- `_config.yml` - Jekyll configuration with site metadata and collection settings
- `_includes/`, `_sass/`, `_site/` - Standard Jekyll directories
- `news-raw/` - Raw text files with collected URLs (excluded from build)

### Key Features  
- Custom collections for news articles (configured in `_config.yml`)
- Multi-language support (French/English posts)
- Social media integration (Twitter, GitHub, LinkedIn)
- RSS feeds via jekyll-feed plugin
- Sitemap generation

### Content Themes
- Technical blog posts focus on Scala, Java, functional programming
- Conference reports (Devoxx, ScalaIO, etc.)
- Development tools and workflows
- Monthly curated news with categorized links (Scala/Java, Data, Other)