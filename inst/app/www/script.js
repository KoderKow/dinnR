// Source: https://community.rstudio.com/t/get-tab-titles-from-all-tabpanels-in-a-tabsetpanel/7958
$(document).on("shiny:connected", function(e) {
    tabNames = [];
    var links = document.getElementsByTagName("a");
    console.log(links);
    for (var i = 0, len = links.length; i < len; i++) {
      if (links[i].getAttribute("href").indexOf("#tab-") === 0) {
        tabNames.push(links[i].getAttribute("id"));
      }
    }
    Shiny.onInputChange("tab_ids", tabNames);
});