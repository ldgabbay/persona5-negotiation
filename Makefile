.PHONY: build server clean

build: _site/_site.d
	@echo

_site/_site.d: local/_config.yml local/_data/navigation.yml _includes/footer.html _includes/header.html _includes/nav.html _layouts/default.html assets/css/style.scss favicon.ico index.md info.md royal.md shadows.md shadows_royal.md local/Gemfile Makefile
	command rm -rf _site local/Gemfile.lock
	docker run --rm -v "$(PWD)":/srv/jekyll --user "$(shell id -u):$(shell id -g)" \
		-e BUNDLE_PATH=/srv/jekyll/local/.bundle \
		-e BUNDLE_GEMFILE=/srv/jekyll/local/Gemfile \
		jekyll/jekyll:latest bash -c "bundle install && bundle exec jekyll build --config _config.yml,local/_config.yml"
	rm _site/shadows.md _site/shadows_royal.md _site/royal.md _site/index.md _site/info.md
	touch _site/_site.d

index.md royal.md: data/tableConverter.py data/persona-5-questions.xlsx data/persona-5-royal-questions.xlsx data/header.index.html data/header.royal.html data/footer.index.html data/footer.royal.html
	uv run --with openpyxl data/tableConverter.py
	command mv -f data/output-original.html index.md
	command mv -f data/output-royal.html royal.md

server: build
	python3 local/server.py -d _site

clean:
	command rm -rf _site
