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
//= require bootstrap-datetimepicker
//= require bootstrap-datetimepicker/pickers
//= require chart
//= require_tree ./templates
//= require_tree
//= require result-chart
//= require jquery-tablesorter
//= require jquery.sortable
//= require jquery.ui.all
$(function(){
$('#selectAll').click(function() {
   if(this.checked) {
       $(':checkbox').each(function() {
           this.checked = true;                        
       });
   } else {
      $(':checkbox').each(function() {
           this.checked = false;                        
       });
   } 
});
});

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



/*$(function() {
    $("#questionTable").sortable({
      update: function(event, ui){
        id = ui.item.data('id')
        position = ui.item.index()
        var itm_arr = $("#questionTable").sortable('toArray');
        var pobj = {questions: itm_arr};
        $.post("questions/reorder", pobj);
        console.log(pobj);
      }
    });
});*/

// Sorting the list

/*$(document).ready(function(){
$('#questionTable').sortable({
axis: 'y',
dropOnEmpty: false,
handle: '.handle',
cursor: 'crosshair',
items: 'table',
opacity: 0.4,
scroll: true,
update: function(){
$.ajax({
type: 'post',
data: $('#questionTable').sortable('serialize'),
dataType: 'script',
complete: function(request){
$('#questionTable').effect('highlight');
},
url: '/questions/reorder'})
}
});
});*/




$(function() {

  $.tablesorter.defaults.widthFixed = true,

  $.tablesorter.defaults.headerTemplate = '{content} {icon}', // needed to add icon for jui theme

  // widget code now contained in the jquery.tablesorter.widgets.js file
  $.tablesorter.defaults.widgets = ['zebra','uitheme', "resizable", "filter", "columns"],
  $.tablesorter.defaults.theme = 'bootstrap'


  $.tablesorter.defaults.widgetOptions = {
    // zebra striping class names - the uitheme widget adds the class names defined in
    // $.tablesorter.themes to the zebra widget class names
    zebra   : ["even", "odd"],

    // If there are child rows in the table (rows with class name from "cssChildRow" option)
    // and this option is true and a match is found anywhere in the child row, then it will make that row
    // visible; default is false
    filter_childRows   : false,

    // if true, filters are collapsed initially, but can be revealed by hovering over the grey bar immediately
    // below the header row. Additionally, tabbing through the document will open the filter row when an input gets focus
    filter_hideFilters : true,

    // Set this option to false to make the searches case sensitive
    filter_ignoreCase  : true,

    // jQuery selector string of an element used to reset the filters
    filter_reset : '.reset',

    // Use the $.tablesorter.storage utility to save the most recent filters
    filter_saveFilters : true,

    // Delay in milliseconds before the filter widget starts searching; This option prevents searching for
    // every character while typing and should make searching large tables faster.
    filter_searchDelay : 300,

    // Set this option to true to use the filter to find text from the start of the column
    // So typing in "a" will find "albert" but not "frank", both have a's; default is false
    filter_startsWith  : false,

    // Add select box to 4th column (zero-based index)
    // each option has an associated function that returns a boolean
    // function variables:
    // e = exact text from cell
    // n = normalized value returned by the column parser
    // f = search filter input value
    // i = column index
    filter_functions : {

      // Add select menu to this column
      // set the column value to true, and/or add "filter-select" class name to header

      // Add these options to the select dropdown (regex example)
      //2 : {
      //  "A - D" : function(e, n, f, i, $r) { return /^[A-D]/.test(e); },
      //  "E - H" : function(e, n, f, i, $r) { return /^[E-H]/.test(e); },
      //  "I - L" : function(e, n, f, i, $r) { return /^[I-L]/.test(e); },
      //  "M - P" : function(e, n, f, i, $r) { return /^[M-P]/.test(e); },
      //  "Q - T" : function(e, n, f, i, $r) { return /^[Q-T]/.test(e); },
      //  "U - X" : function(e, n, f, i, $r) { return /^[U-X]/.test(e); },
      //  "Y - Z" : function(e, n, f, i, $r) { return /^[Y-Z]/.test(e); }
      //},

      // Add these options to the select dropdown (numerical comparison example)
      // Note that only the normalized (n) value will contain numerical data
      // If you use the exact text, you'll need to parse it (parseFloat or parseInt)
      //3 : {
      //  "< $10"      : function(e, n, f, i, $r) { return n < 10; },
      //  "$10 - $100" : function(e, n, f, i, $r) { return n >= 10 && n <=100; },
      // "> $100"     : function(e, n, f, i, $r) { return n > 100; }
      //}
    }
    
  },
  
  // call the tablesorter plugin
  
  $("#questionTable").tablesorter({ 
     headers: { 
          // assign the secound column (we start counting zero) 
          0: { 
              // disable it by setting the property sorter to false 
              sorter: false,
              filter: false
          },
          5: { 
              // disable it by setting the property sorter to false 
              sorter: false,
              filter: false
          }
      }
   });
  $("#surveyTable").tablesorter({ 
    headers: { 
        // assign the secound column (we start counting zero) 
        0: { 
            // disable it by setting the property sorter to false 
            sorter: false,
            filter: false
        },
        1: { 
            // disable it by setting the property sorter to false 
            sorter: false,
            filter: false
        },
        7: { 
            // disable it by setting the property sorter to false 
            sorter: false,
            filter: false
        }
    }
   });
   $("#userTable").tablesorter({
    headers: { 
          // assign the secound column (we start counting zero) 
          0: { 
              // disable it by setting the property sorter to false 
              sorter: false,
              filter: false
          },
          4: { 
              // disable it by setting the property sorter to false 
              sorter: false,
              filter: false
          }
      }
  });

}); 