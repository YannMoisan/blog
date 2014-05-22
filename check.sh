# ... => …
find src -name "*.html" | xargs grep "\.\.\."
# i.e. => c.-à-d.
find src -name "*.html" | xargs grep "[^,] …"
find src -name "*.html" | xargs grep "i\.e\."
# find line where sentence have a missing point.
find src -name "*.html" | xargs grep "[^.:!\?…]</p>"
# find src -name '*.html' -exec sed -i 's/\.\.\./…/g' {} \;
# find src -name '*.html' -exec sed -i 's/\([^,]\) …/\1…/g' {} \;
# find src -name '*.html' -exec sed -i 's/i\.e\./c.-à-d./g' {} \;
# :vimgrep /[^.:…]<\/p>/ *.html
