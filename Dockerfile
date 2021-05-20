FROM rocker/r-ver:4.0.3
RUN apt-get update && apt-get install -y  git-core libcurl4-openssl-dev libgit2-dev libicu-dev libssl-dev libxml2-dev make pandoc pandoc-citeproc && rm -rf /var/lib/apt/lists/*
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)" >> /usr/local/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_version("magrittr",upgrade="never", version = "2.0.1")'
RUN Rscript -e 'remotes::install_version("rlang",upgrade="never", version = "0.4.10")'
RUN Rscript -e 'remotes::install_version("processx",upgrade="never", version = "3.4.5")'
RUN Rscript -e 'remotes::install_version("stringr",upgrade="never", version = "1.4.0")'
RUN Rscript -e 'remotes::install_version("htmltools",upgrade="never", version = "0.5.1.1")'
RUN Rscript -e 'remotes::install_version("scales",upgrade="never", version = "1.1.1")'
RUN Rscript -e 'remotes::install_version("dplyr",upgrade="never", version = "1.0.2")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.6.0")'
RUN Rscript -e 'remotes::install_version("usethis",upgrade="never", version = "2.0.1")'
RUN Rscript -e 'remotes::install_version("testthat",upgrade="never", version = "3.0.2")'
RUN Rscript -e 'remotes::install_version("config",upgrade="never", version = "0.3.1")'
RUN Rscript -e 'remotes::install_version("tidyr",upgrade="never", version = "1.1.2")'
RUN Rscript -e 'remotes::install_version("spelling",upgrade="never", version = "2.2")'
RUN Rscript -e 'remotes::install_version("plyr",upgrade="never", version = "1.8.6")'
RUN Rscript -e 'remotes::install_version("measurements",upgrade="never", version = "1.4.0")'
RUN Rscript -e 'remotes::install_version("googlesheets4",upgrade="never", version = "0.2.0")'
RUN Rscript -e 'remotes::install_version("waiter",upgrade="never", version = "0.2.0")'
RUN Rscript -e 'remotes::install_version("tippy",upgrade="never", version = "0.1.0")'
RUN Rscript -e 'remotes::install_version("shinyjs",upgrade="never", version = "2.0.0")'
RUN Rscript -e 'remotes::install_version("sever",upgrade="never", version = "0.0.6")'
RUN Rscript -e 'remotes::install_version("lubridate",upgrade="never", version = "1.7.9")'
RUN Rscript -e 'remotes::install_version("gt",upgrade="never", version = "0.2.2")'
RUN Rscript -e 'remotes::install_version("golem",upgrade="never", version = "0.3.1")'
RUN Rscript -e 'remotes::install_version("DT",upgrade="never", version = "0.16")'
RUN Rscript -e 'remotes::install_github("JohnCoene/cicerone@3b44698f1edd1de91f878bc5de9b008a3b37c0b3")'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="never")'
RUN rm -rf /build_zone
EXPOSE 80
CMD Rscript deploy.R
