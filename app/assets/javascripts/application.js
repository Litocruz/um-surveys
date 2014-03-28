// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require underscore
//= require twitter/bootstrap
//= require chart
//= require_tree ./templates
//= require result-chart

function show_confirm_modal(path, question){
    $('#confirm-modal #question').text(question);	
    $('#confirm-modal #delete').on("click", function(){
        $.ajax({
            async: false,
            type: "DELETE",
            url: path,
            success: function() {$('#confirm-modal').modal('hide');},
            dataType: 'script'
        });   
        $('#confirm-modal').modal('hide');    
    });
    $('#confirm-modal').show();
}

$(function(){
    $("a[data-remote='true']").on("click", function(){
        history.pushState({
            path:this.href
            }, "", this.href);
    });
    
    $("#table_div .pagination a, #table_div th a").on("click", function(){
        $.getScript(this.href);
        history.pushState({
            path:this.href
            }, "", this.href.replace("ajax_search=true", "ajax_search="));
        return false;
    });
    
    $("#quicksearch input").on("keyup",function(){
        var form = $("#ajax_search_form");
        var url = form.attr('action') + '?' + form.serialize();
        url = url.replace("ajax_search=true", "ajax_search=");
        history.pushState({
            path:url
        }, "", url);

        $.get(form.attr("action"), form.serialize(), null, "script");        
    });
});