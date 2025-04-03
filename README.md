# Linux Libertinus

This repository is not a fork, but a Google-Fonts-centered working repository, of the popular [https://github.com/alerque/libertinus](https://github.com/alerque/libertinus) font family.

# Build

The build script `build.sh` downloads the latest release from [https://github.com/alerque/libertinus](https://github.com/alerque/libertinus) as a zip file, unpacks and hotfixes the TTF binaries to suit Google Fonts specifications as close as possible.

This is currently intended as a manual process but can be automated as part of a Github Action. For this purpose, each upstream release’s version is mirrored in `version.txt` to be comparable as part of a Github Action to decide on whether or not a PR to this repository shall be triggered.

# Contributions

If you find issues with the font character sets or designs, please refer directly to [https://github.com/alerque/libertinus](https://github.com/alerque/libertinus).

Google Fonts will publish new releases after they become available through the upstream repository.