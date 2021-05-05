
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![R-CMD-check](https://github.com/KoderKow/dinnR/workflows/R-CMD-check/badge.svg)](https://github.com/KoderKow/dinnR/actions)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
<!-- badges: end -->

# {dinnR} <img src="https://raw.githubusercontent.com/koderkow/dinnr/master/inst/other/hex-dinnR.png" align="right" alt="" width="120" />

<https://koderkow.shinyapps.io/dinnR/>

Hello\! Thank you for checking out the dinnR app\! This app was made to
simplify the dinner planning process. dinnR helps to create a weekly
meal plan and generate a shopping list to show the ingredients needed
for the week. If you would like to add a recipe to the app, you can make
a submission [here](https://forms.gle/T5pHyzZrNhzDrEd37). Please be sure
to include your information if you would like to be credited\!

We do stream the making of this app over on our [Twitch
channel](https://twitch.tv/theeatgamelove), so come say hello and let us
know if you have any comments or ideas\! Join our
[discord](https://discord.gg/hrec3NP) and talk with us in the
\#dinnr-suggestions channel as well. \<3

## Dev Notes

Update the package dependencies with

``` r
attachment::att_amend_desc(
  extra.suggests = c(
    "rlang",
    attachment::att_from_rscript("data-raw/dinn.R")
  )
)
```

## Thanks To …

  - Colin Fay’s [hexmake](https://connect.thinkr.fr/hexmake/) app for
    making the hex sticker for dinnR
  - Stefan Eng’s [blog
    post](https://stefanengineering.com/2019/07/06/delete-rows-from-shiny-dt-datatable/)
    for adding a column of delete icons for the ingredient list
  - ginberg’s post on [RStudio
    Community](https://community.rstudio.com/t/get-tab-titles-from-all-tabpanels-in-a-tabsetpanel/7958)
    on aquiring tabPanel ID’s
