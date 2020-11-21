** code is hosted on [gitlab](https://gitlab.com/reubenbrown13/contento_website) now **


# Contento

> An open source CMS built with the power of Elixir, Phoenix and Postgresql.

![Contento Admin Screenshot](https://raw.githubusercontent.com/contentocms/contento/master/screenshot.png)

#### Disclaimer

This project is currently a WIP and documentation, guides and more info is on it's way, stay tuned by staring this repo!

Many things may change before a stable version comes out, if you have any idea/suggestion/contribution, feel free to do go ahead!

If you would like to join discussion about this project, join `#contento` channel on [Elixir Slack](https://elixir-slackin.herokuapp.com/).

## Getting Started

1. Install the Contento archive, if you haven't already done so:

```
$ mix archive.install https://github.com/contentocms/contento_new/raw/master/releases/contento.new.ez
```

2. Create your new website with:

```
$ mix contento.new [directory]
```

This command will do a few things for you, including: cloning this repo to given directory, fetch and install dependencies, compile back-office assets, generate configuration files with defaults, create database and run migrations, install default theme [Simplo](https://github.com/contentocms/simplo) and setup Contento with defaults.

3. Your website is ready! Now you can access your website on `http://localhost:4000` or `http://localhost:4000/login` to access back-office.

Default user credentials are:

- Email: **contento@example.org**
- Password: **contento**

**NOTE:** Check [ROADMAP.md](https://github.com/contentocms/contento/blob/master/ROADMAP.md) for current features and what's expected to come next.

## Contributing

Info for contributing to this project will be here soon, in the meanwhile just submit your PRs!

## License

This project is licensed under the [MIT license](https://github.com/contentocms/contento/blob/master/LICENSE.md).
