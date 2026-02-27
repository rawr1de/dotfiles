#!/bin/bash
# Org-Mode Notes Repository Setup Script
# This creates a complete system for beautiful org-mode exports

echo "Creating org-notes repository structure..."

# Create directory structure
mkdir -p org-notes/{notes,exports/{html,pdf},assets,scripts}
cd org-notes

# Create beautiful CSS for HTML exports
cat > assets/style.css << 'EOF'
/* Modern, clean stylesheet for org-mode HTML exports */

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    max-width: 850px;
    margin: 60px auto;
    padding: 0 30px;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    font-size: 16px;
    line-height: 1.7;
    color: #24292e;
    background: #ffffff;
}

/* Headers */
h1 {
    font-size: 2.5em;
    font-weight: 600;
    color: #1a1a1a;
    margin-bottom: 0.5em;
    padding-bottom: 0.3em;
    border-bottom: 3px solid #0366d6;
}

h2 {
    font-size: 1.8em;
    font-weight: 600;
    color: #1a1a1a;
    margin-top: 1.5em;
    margin-bottom: 0.5em;
    padding-bottom: 0.2em;
    border-bottom: 1px solid #eaecef;
}

h3 {
    font-size: 1.4em;
    font-weight: 600;
    color: #1a1a1a;
    margin-top: 1.2em;
    margin-bottom: 0.5em;
}

h4 {
    font-size: 1.2em;
    font-weight: 600;
    color: #1a1a1a;
    margin-top: 1em;
    margin-bottom: 0.5em;
}

/* Paragraphs */
p {
    margin-bottom: 1em;
}

/* Links */
a {
    color: #0366d6;
    text-decoration: none;
    transition: color 0.2s;
}

a:hover {
    color: #0056b3;
    text-decoration: underline;
}

/* Code blocks */
code {
    background: #f6f8fa;
    padding: 3px 6px;
    border-radius: 3px;
    font-size: 90%;
    font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, monospace;
    color: #e83e8c;
}

pre {
    background: #f6f8fa;
    padding: 16px;
    border-radius: 6px;
    overflow-x: auto;
    margin: 1.5em 0;
    border: 1px solid #e1e4e8;
    line-height: 1.45;
}

pre code {
    background: transparent;
    padding: 0;
    color: #24292e;
    border-radius: 0;
}

/* Lists */
ul, ol {
    margin-left: 2em;
    margin-bottom: 1em;
}

li {
    margin-bottom: 0.5em;
}

/* Blockquotes */
blockquote {
    border-left: 4px solid #dfe2e5;
    padding-left: 1em;
    margin: 1.5em 0;
    color: #6a737d;
    font-style: italic;
}

/* Tables */
table {
    border-collapse: collapse;
    width: 100%;
    margin: 1.5em 0;
    overflow-x: auto;
    display: block;
}

th, td {
    border: 1px solid #dfe2e5;
    padding: 8px 12px;
    text-align: left;
}

th {
    background: #f6f8fa;
    font-weight: 600;
}

tr:nth-child(even) {
    background: #f6f8fa;
}

/* Table of Contents */
#table-of-contents {
    background: #f6f8fa;
    padding: 20px;
    border-radius: 6px;
    margin: 2em 0;
    border: 1px solid #e1e4e8;
}

#table-of-contents h2 {
    margin-top: 0;
    border-bottom: none;
    font-size: 1.3em;
}

#table-of-contents ul {
    margin-left: 1em;
}

/* Metadata section */
#postamble {
    margin-top: 3em;
    padding-top: 1em;
    border-top: 1px solid #e1e4e8;
    font-size: 0.9em;
    color: #6a737d;
}

/* Responsive design */
@media (max-width: 768px) {
    body {
        margin: 30px auto;
        padding: 0 15px;
        font-size: 14px;
    }
    
    h1 { font-size: 2em; }
    h2 { font-size: 1.5em; }
    h3 { font-size: 1.3em; }
}

/* Print styles */
@media print {
    body {
        max-width: 100%;
        margin: 0;
        padding: 20px;
        font-size: 12pt;
    }
    
    a {
        color: #000;
        text-decoration: underline;
    }
    
    pre {
        border: 1px solid #000;
    }
}
EOF

# Create alternative dark theme CSS
cat > assets/style-dark.css << 'EOF'
/* Dark theme for org-mode HTML exports */

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    max-width: 850px;
    margin: 60px auto;
    padding: 0 30px;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    font-size: 16px;
    line-height: 1.7;
    color: #e6edf3;
    background: #0d1117;
}

h1 {
    font-size: 2.5em;
    font-weight: 600;
    color: #e6edf3;
    margin-bottom: 0.5em;
    padding-bottom: 0.3em;
    border-bottom: 3px solid #58a6ff;
}

h2 {
    font-size: 1.8em;
    font-weight: 600;
    color: #e6edf3;
    margin-top: 1.5em;
    margin-bottom: 0.5em;
    padding-bottom: 0.2em;
    border-bottom: 1px solid #21262d;
}

h3, h4 {
    color: #e6edf3;
    margin-top: 1.2em;
    margin-bottom: 0.5em;
}

a {
    color: #58a6ff;
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}

code {
    background: #161b22;
    padding: 3px 6px;
    border-radius: 3px;
    color: #ff7b72;
    font-family: "SFMono-Regular", Consolas, monospace;
}

pre {
    background: #161b22;
    padding: 16px;
    border-radius: 6px;
    overflow-x: auto;
    margin: 1.5em 0;
    border: 1px solid #30363d;
}

pre code {
    background: transparent;
    color: #e6edf3;
}

ul, ol {
    margin-left: 2em;
    margin-bottom: 1em;
}

blockquote {
    border-left: 4px solid #30363d;
    padding-left: 1em;
    color: #8b949e;
}

table {
    border-collapse: collapse;
    width: 100%;
    margin: 1.5em 0;
}

th, td {
    border: 1px solid #30363d;
    padding: 8px 12px;
}

th {
    background: #161b22;
}

tr:nth-child(even) {
    background: #161b22;
}

#table-of-contents {
    background: #161b22;
    padding: 20px;
    border-radius: 6px;
    border: 1px solid #30363d;
}
EOF

# Create export sync script
cat > scripts/export-and-sync.sh << 'EOF'
#!/bin/bash
# Export all .org files to HTML and PDF, then sync to git

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo "🔄 Exporting org files..."

# Export all .org files
for file in notes/*.org; do
    if [ -f "$file" ]; then
        echo "  📄 Exporting $(basename "$file")..."
        
        # Export to HTML
        emacs "$file" --batch \
            --eval "(setq org-html-head-include-default-style nil)" \
            --eval "(setq org-html-head-include-scripts nil)" \
            -f org-html-export-to-html --kill 2>/dev/null
        
        # Export to PDF (if you have LaTeX installed)
        emacs "$file" --batch \
            -f org-latex-export-to-pdf --kill 2>/dev/null
    fi
done

# Move exports to proper directories
echo "📦 Moving exports..."
[ -f notes/*.html ] && mv notes/*.html exports/html/ 2>/dev/null
[ -f notes/*.pdf ] && mv notes/*.pdf exports/pdf/ 2>/dev/null

echo "✅ Export complete!"

# Git sync (if in a git repo)
if [ -d .git ]; then
    echo "🔄 Syncing with git..."
    git add .
    git commit -m "Update notes: $(date +%Y-%m-%d\ %H:%M)"
    git push
    echo "✅ Synced to remote!"
else
    echo "ℹ️  Not a git repository. Skipping sync."
fi
EOF

chmod +x scripts/export-and-sync.sh

# Create quick export script (no git sync)
cat > scripts/export-only.sh << 'EOF'
#!/bin/bash
# Export all .org files to HTML and PDF (no git sync)

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo "🔄 Exporting org files..."

for file in notes/*.org; do
    if [ -f "$file" ]; then
        echo "  📄 Exporting $(basename "$file")..."
        emacs "$file" --batch \
            --eval "(setq org-html-head-include-default-style nil)" \
            --eval "(setq org-html-head-include-scripts nil)" \
            -f org-html-export-to-html --kill 2>/dev/null
        emacs "$file" --batch \
            -f org-latex-export-to-pdf --kill 2>/dev/null
    fi
done

[ -f notes/*.html ] && mv notes/*.html exports/html/ 2>/dev/null
[ -f notes/*.pdf ] && mv notes/*.pdf exports/pdf/ 2>/dev/null

echo "✅ Export complete!"
echo "📁 HTML files: exports/html/"
echo "📁 PDF files: exports/pdf/"
EOF

chmod +x scripts/export-only.sh

# Create example org file
cat > notes/example.org << 'EOF'
#+TITLE: Example Document
#+AUTHOR: Your Name
#+DATE: 2025-11-10
#+OPTIONS: toc:2 num:t
#+HTML_HEAD: <link rel="stylesheet" type="text/css" href="../assets/style.css" />
#+LATEX_CLASS: article
#+LATEX_HEADER: \usepackage{geometry}
#+LATEX_HEADER: \geometry{margin=1in}

* Introduction

This is an example org-mode document showing various features.

** Formatting

You can use *bold*, /italic/, _underlined_, and =code= text.

** Code Blocks

Here's some code:

#+BEGIN_SRC python
def hello_world():
    print("Hello from org-mode!")
    return True
#+END_SRC

** Lists

*** Unordered Lists
- First item
- Second item
  - Nested item
  - Another nested item
- Third item

*** Ordered Lists
1. First step
2. Second step
3. Third step

** Tables

| Language | Difficulty | Fun Factor |
|----------+------------+------------|
| Python   | Easy       | High       |
| Rust     | Hard       | Very High  |
| Lisp     | Medium     | Extreme    |

** Links

Visit [[https://orgmode.org][Org Mode website]] for more information.

** Quotes

#+BEGIN_QUOTE
Org mode is the best way to stay organized while keeping everything in plain text.
#+END_QUOTE

* Advanced Features

** TODO Tasks

*** TODO Write more documentation
*** DONE Set up org-mode
    CLOSED: [2025-11-10]

** Math (if LaTeX is installed)

Inline math: \(E = mc^2\)

Display math:
\[
\int_0^\infty e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
\]

* Conclusion

This template provides a solid foundation for your org-mode notes system.
Export to HTML or PDF and sync with git!
EOF

# Create README
cat > README.md << 'EOF'
# Org-Mode Notes System

A beautiful, git-synced system for org-mode notes with HTML and PDF exports.

## 📁 Structure

```
org-notes/
├── notes/           # Your .org files go here
├── exports/         # Generated exports
│   ├── html/       # HTML versions
│   └── pdf/        # PDF versions
├── assets/          # CSS and other assets
│   ├── style.css   # Light theme
│   └── style-dark.css  # Dark theme
└── scripts/         # Helper scripts
```

## 🚀 Quick Start

1. **Write your notes** in `notes/` using Emacs org-mode

2. **Export manually** (in Emacs):
   - `C-c C-e h h` - Export to HTML
   - `C-c C-e l p` - Export to PDF

3. **Or use scripts**:
   ```bash
   ./scripts/export-only.sh        # Just export
   ./scripts/export-and-sync.sh    # Export + git sync
   ```

## 🎨 Switching Themes

To use dark theme, edit your .org file header:
```org
#+HTML_HEAD: <link rel="stylesheet" type="text/css" href="../assets/style-dark.css" />
```

## 📤 Git Setup

```bash
cd org-notes
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/yourusername/org-notes.git
git push -u origin main
```

## 🌐 GitHub Pages (Optional)

1. Enable GitHub Pages in repo settings
2. Set source to `main` branch, `/exports/html` folder
3. Access at: `https://yourusername.github.io/org-notes/`

## 📥 Access From Anywhere

```bash
# Clone on another machine
git clone https://github.com/yourusername/org-notes.git

# Download single file
curl -O https://raw.githubusercontent.com/yourusername/org-notes/main/exports/html/example.html

# Sync changes
git pull
```

## 💡 Tips

- Keep each note as a separate .org file
- Use consistent naming: `2025-11-10-topic.org`
- Run `export-and-sync.sh` after editing
- View HTML files in any browser offline

## 📚 Learn More

- [Org Mode Manual](https://orgmode.org/manual/)
- [Org Export Reference](https://orgmode.org/manual/Exporting.html)
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
# Emacs temporary files
*~
\#*\#
.\#*
.DS_Store

# Org-mode temporary files
*.tex
*.aux
*.log
*.out
*.toc

# Keep exports but ignore if you prefer
# exports/html/*.html
# exports/pdf/*.pdf
EOF

# Initialize git
git init
git add .
git commit -m "Initial org-notes setup"

echo ""
echo "✅ Setup complete!"
echo ""
echo "📁 Created: org-notes/"
echo ""
echo "🎯 Next steps:"
echo "   1. cd org-notes"
echo "   2. Edit notes/example.org in Emacs"
echo "   3. Export with: C-c C-e h h (HTML) or C-c C-e l p (PDF)"
echo "   4. Or run: ./scripts/export-only.sh"
echo ""
echo "🐙 To sync with GitHub:"
echo "   1. Create a repo on GitHub"
echo "   2. git remote add origin https://github.com/yourusername/org-notes.git"
echo "   3. git push -u origin main"
echo "   4. Use ./scripts/export-and-sync.sh to auto-sync"
echo ""
echo "📖 Check README.md for full documentation"
echo ""
EOF