# rwedev 0.0.0.9000

* Follows RWE standards `v2` (`Config/rwe/standards: v2`) and has the managed
  `air.toml`.
* Removed the templates bundled in `inst/templates/`: the templates in
  rwe-ecosystem's `templates/` folder are the only source. The R code still
  reads the bundled copies and will be updated to use the new source.
