// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import $ from "jquery";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
var strtdt = 0, enddt = 0;
var working = false;

function update_buttons() {
  $('.manage-button').each( (_, bb) => {
    let user_id = $(bb).data('user-id');
    let mid = $(bb).data('user-manager-id');

    if (mid == "" || mid == null) {
      $(bb).text("Manage");
    }
    else {
      $(bb).text("Unmanage");
    }
  });
}

function set_button(user_id, value) {
  $('.manage-button').each( (_, bb) => {
    if (user_id == $(bb).data('user-id')) {
      $(bb).data('user-manager-id', value);
    }
  });
  update_buttons();
}

function manage(user_id, manager_id) {
  let text = JSON.stringify({
  	id : {
  		userid: user_id
  	},
    user: {
        manager_id: manager_id
      },
  });

  $.ajax("/userupdate", {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => {  },
  });
  set_button(user_id, manager_id);
}

function unmanage(user_id, manager_id) {
  let text = JSON.stringify({
  	id : {
  		userid : user_id
  	},
    user: {
        manager_id: null
      },
  });

  $.ajax("/userupdate", {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => {  },
  });
  set_button(user_id, null);
}

function manage_click(ev) {
  let btn = $(ev.target);
  let mid = btn.data('user-manager-id');
  let user_id = btn.data('user-id');
  if (mid == "" || mid == null) {
    manage(user_id, manager_id);
  }
  else {
    unmanage(user_id, manager_id);
  }
}

function update_buttons_timetrack() {
  $('.timetrack-button').each( (_, bb) => {
    let task_id = $(bb).data('task-id');
    let active_id = $(bb).data('active-id');

    if (active_id == "yes") {
      $(bb).text("Stop Task");
    }
    else {
      $(bb).text("Start Task");
    }
  });
}

function set_button_toggle(task_id, value) {
  $('.timetrack-button').each( (_, bb) => {
    if (task_id == $(bb).data('task-id')) {
      $(bb).data('active-id', value);
    }
  });
  update_buttons_timetrack();
}

function stopTask(task_id) {
  enddt = new Date($.now());
  set_button_toggle(task_id, "no");
  let text = JSON.stringify({
    timetrack: {
      task_id: task_id,
      start_time: strtdt,
      end_time: enddt
    },
  });
  
  $.ajax(timetrack, {
    method: "post",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
    success: (resp) => {set_button_toggle(task_id, "no");},
    error: () => { alert("failed");}
  });
   
}

function startTask(task_id) {
  strtdt = new Date($.now());
  set_button_toggle(task_id, "yes"); 
}

function timetrack_click(ev) {
  let btn = $(ev.target);
  let tid = btn.data('task-id');
  let active_id = btn.data('active-id');
  
  if (active_id == "no") {
    startTask(tid);
  }
  else {
    stopTask(tid);
  }
}

function init_manage() {
  if (!$(".manage-button")) {
    return;
  }

  $(".manage-button").click(manage_click);
  $(".timetrack-button").click(timetrack_click);

  update_buttons();
  update_buttons_timetrack();
}

$(init_manage);
