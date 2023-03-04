var ocorrencias = 0;
var atendidas = 0;

window.addEventListener('message', function (event) {
     switch(event.data.action) {
          case "PushAlerta":
               PushAlertas(event.data)
               UpdateAlerta(event.data)
               break;
          case "AbrirAlertas":
               OpenDispatch()
               break;
          case "UpdateAlertas":
               UpdateAlerta(event.data)
               break;
     }
});

$(document).ready(function(){
     $('.tooltipped').tooltip();
});
 
$(document).ready(function(){
     $(".search-dispatch").on("keyup", function() {
         var value = $(this).val().toLowerCase();
         $(".rb-item2").filter(function() {
           $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
         });
     });
 });

OpenDispatch = function () {
     $(".alertas-container").fadeIn('fast');  
}

PushAlertas = function (data) {
     var randId = Math.floor((Math.random() * 10000) + 1);
     var tempo = 5000
     if (data.alerta.coords != undefined && data.alerta.coords != null) {
          var html = '<li class="rb-item '+randId+'" id="alert-'+randId+'" ng-repeat="itembx"><div class="timestamp">' + data.alerta.title + '</div><i class="material-icons gps-icone">location_on</i><div class="item-title">' + data.alerta.description + '</div></li>'
     }
     
     // $(html).hide().appendTo(".notify-container").fadeIn(0);
     $(".addalertaspush").prepend(html).fadeIn('fast');
     ocorrencias = ocorrencias + 1
     $('.qtd-ocorrencias').html((ocorrencias));
     $("#alert-"+randId).addClass('ativando');
     
     setTimeout(function () {
           $('.'+randId).removeClass('ativando');
          setTimeout(function(){
              
               setTimeout(function(){
                    var remove = document.getElementById('alert-'+randId);
                    remove.remove();
               }, 1000);        
          }, 1500);
     }, tempo);
}

var idsoundplay = 1

UpdateAlerta = function (data) {
     var randId = Math.floor((Math.random() * 10000) + 1);
     var AlertElement = '';

     if (data.alerta.coords != undefined && data.alerta.coords != null) {
          AlertElement = '<li class="rb-item2" id="alert-'+randId+'" ng-repeat="itembx"><div class="timestamp">'+data.alerta.title+'</div><i class="material-icons gps-icone">location_on</i><div class="item-title">'+data.alerta.description+'</div></li>';
      } else {
          AlertElement = '<div class="meos-alert" id="alert-'+randId+'"> <span class="meos-alert-new" style="margin-bottom: 1vh;">NEW</span> <p class="meos-alert-type">Notification: '+data.alerta.title+'</p> <p class="meos-alert-description">'+data.alerta.description+'</p></div>';
     }
     
     if (data.alerta.title == "Colleague Backup") {
          $(".meos-recent-alert").css({"background-color":"#d30404"}); 
          $(".meos-recent-alert").addClass("panicbutton");
     }
     
     $(".addalertas").prepend(AlertElement);
     $("#alert-"+randId).data("alertData", data.alerta);
     $("#recent-alert-" + randId).data("alertData", data.alerta);
}


$(document).on('click', '.gps-icone', function(e){
     e.preventDefault();
     atendidas = atendidas + 1
     $('.qtd-atendidas').html((atendidas));
     var alertData = $(this).parent().data("alertData");
     //console.log(alertData)
     $.post('http://reborn_dispatch/SetarWaypoint', JSON.stringify({
         alert: alertData,
     }));
});
 
$(document).on('click', '.apagar-dispatchs', function(e){
     e.preventDefault();
     $(".addalertas").html('');
});

 $(document).on('keydown', function() {
     switch(event.keyCode) {
         case 27: // ESCAPE
             $(".alertas-container").fadeOut('fast');
               $.post('http://reborn_dispatch/FecharDispatch', JSON.stringify());
             break;
     }
 });