let ocorrencias = 0;
let atendidas = 0;

$(document).ready(function () {
    $('.tooltipped').tooltip();

    $(".search-dispatch").on("keyup", function () {
        const value = $(this).val().toLowerCase();
        $(".rb-item2").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
        });
    });
});

window.addEventListener('message', function (event) {
    const data = event.data;
    switch (data.action) {
        case "PushAlerta":
            PushAlertas(data);
            UpdateAlerta(data);
            break;
        case "AbrirAlertas":
            OpenDispatch();
            break;
        case "UpdateAlertas":
            UpdateAlerta(data);
            break;
    }
});

const OpenDispatch = () => {
    $(".alertas-container").fadeIn('fast');
}

const PushAlertas = (data) => {
    const randId = Math.floor((Math.random() * 10000) + 1);
    const tempo = 5000;
    let html = '';
    if (data.alerta.coords != undefined && data.alerta.coords != null) {
        html = `<li class="rb-item ${randId}" id="alert-${randId}" ng-repeat="itembx">
                    <div class="timestamp">${data.alerta.title}</div>
                    <i class="material-icons gps-icone">location_on</i>
                    <div class="item-title">${data.alerta.description}</div>
                </li>`;
    }

    $(".addalertaspush").prepend(html).fadeIn('fast');
    ocorrencias++;
    $('.qtd-ocorrencias').html(ocorrencias);
    $(`#alert-${randId}`).addClass('ativando');

    setTimeout(() => {
        $(`.${randId}`).removeClass('ativando');
        setTimeout(() => {
            setTimeout(() => {
                $(`#alert-${randId}`).remove();
            }, 1000);
        }, 1500);
    }, tempo);
}

const UpdateAlerta = (data) => {
    const randId = Math.floor((Math.random() * 10000) + 1);
    let AlertElement = '';

    if (data.alerta.coords != undefined && data.alerta.coords != null) {
        AlertElement = `<li class="rb-item2" id="alert-${randId}" ng-repeat="itembx">
                            <div class="timestamp">${data.alerta.title}</div>
                            <i class="material-icons gps-icone">location_on</i>
                            <div class="item-title">${data.alerta.description}</div>
                        </li>`;
    } else {
        AlertElement = `<div class="meos-alert" id="alert-${randId}">
                            <span class="meos-alert-new" style="margin-bottom: 1vh;">NEW</span>
                            <p class="meos-alert-type">Notification: ${data.alerta.title}</p>
                            <p class="meos-alert-description">${data.alerta.description}</p>
                        </div>`;
    }

    if (data.alerta.title == "Colleague Backup") {
        $(".meos-recent-alert").css({"background-color":"#d30404"}).addClass("panicbutton");
    }

    $(".addalertas").prepend(AlertElement);
    $(`#alert-${randId}`).data("alertData", data.alerta);
    $(`#recent-alert-${randId}`).data("alertData", data.alerta);
}

$(document).on('click', '.gps-icone', function(e){
    e.preventDefault();
    atendidas++;
    $('.qtd-atendidas').html(atendidas);
    const alertData = $(this).parent().data("alertData");
    $.post('http://reborn_dispatch/SetarWaypoint', JSON.stringify({alert: alertData}));
});
 
$(document).on('click', '.apagar-dispatchs', function(e){
    e.preventDefault();
    $(".addalertas").html('');
});

$(document).on('keydown', function(event) {
    switch(event.keyCode) {
        case 27: // ESCAPE
            $(".alertas-container").fadeOut('fast');
            $.post('http://reborn_dispatch/FecharDispatch', JSON.stringify({}));
            break;
    }
});
