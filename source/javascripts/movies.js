$(document).ready(function() {
  $("a.player-selector-a").click(function (e) {
    $("div.embedded-movie-container-div .default-player").css("display", "none");

    $("div.embedded-movie-container-div .fallback-player").css("display", "block");
    $("div.embedded-movie-container-div .fallback-player").css("margin", "0 auto");
  });
});
