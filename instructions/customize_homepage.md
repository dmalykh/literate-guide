# Customize Your Web Server

Web servers like nginx serve static files to visitors who access your website. When someone types your website's URL into their browser, nginx looks for an `index.html` file in its web directory and sends that content back to display in the browser.

## Understanding Web Server File Structure

Nginx stores its web files in `/usr/share/nginx/html/` by default. The main file, `index.html`, contains the HTML code that creates your homepage. Any changes you make to this file will immediately be visible to visitors since nginx serves static files directly without requiring a restart.

## Working with HTML Files

HTML (HyperText Markup Language) uses tags to structure content. You can add text, headings, paragraphs, and other elements by using HTML tags like:

- `<h1>` for main headings
- `<p>` for paragraphs
- `<strong>` for bold text

## Editing Files on a Server

Minimal container images like nginx ship without a text editor, so you change files with shell commands instead. In the Terminal tab, replace the homepage with your own message:

```bash
echo '<h1>Hello from my web server!</h1>' > /usr/share/nginx/html/index.html
```

Verify your change with `cat`:

```bash
cat /usr/share/nginx/html/index.html
```

To see your changes, refresh your browser or the Service tab.

<instruqt-task id="edit_homepage"></instruqt-task>

## Troubleshooting

**Can't find the file?**

- Make sure you're in the right directory: `/usr/share/nginx/html`
- List files with: `ls -la`

**Changes not showing?**

- Force refresh the Service tab (Ctrl+F5 or Cmd+Shift+R)
- Wait a few seconds and refresh again
