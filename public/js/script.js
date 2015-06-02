$(document).ready(function(){
  $("#hint").on("click", function(e){
    e.preventDefault();
    $.get("/use_hint", function(data){
      $("#result").append("<tr><td>Hint:</td><td>"+data+"</td></tr>");
      $("#hint").remove();
    });
  });

  $("#guess_code").on("submit", function(e){
    e.preventDefault();
    var code = $('input[name="guess_code"]').val();
    var links = '<a href="/" class="btn btn-primary">Restart game</a>&nbsp;&nbsp;&nbsp;<a href="/save_score" class="btn btn-primary">Save score</a>'
    $.post("/guess_code", {guess_code: code}, function(data){
      var arr = data.split("|");
      $("#result").append("<tr><td>Code: " + code + "</td><td>Guess: "+arr[0]+"</td></tr>");
      $("#attempts").html(arr[1]);
      if(arr[0] == "Lose!" || arr[0] == "Win!"){
        $("#guess_code").remove();
        $(links).insertAfter("#result");
      }
    });
  });
});
