$(document).ready(function() {
  function taskHtml(task) {
    return '<li class="' + (task.done ? "completed" : "") +
      '" id="listItem-' + task.id + '">' +
      '<div class="view"><input class="toggle" type="checkbox" data-id="' +
      task.id + '" ' + (task.done ? "checked" : "") + '><label>' +
      task.title + '</label></div></li>';
  }

  function toggleTask(e) {
    $.post("/tasks/" + $(e.target).data('id'), {
      _method: "PUT",
      task: {
        done: Boolean($(e.target).is(':checked'))
      }
    }).then(function(data) {
      $("#listItem-" + data.id).replaceWith(taskHtml(data));
      $('.toggle').change(toggleTask);
    });
  }

  $.get("/tasks").then(function(data) {
    var htmlString = "";
    $.each(data, function(index, task) {
      htmlString += taskHtml(task);
    });
    $('.todo-list').html(htmlString);
    $('.toggle').change(toggleTask);
  });

  $('#new-task-form').submit(function(e) {
    e.preventDefault();
    var payload = {
      task: {
        title: $('.new-task').val()
      }
    };
    $.post("/tasks", payload).then(function(data) {
      $('.todo-list').append(taskHtml(data));
      $('.toggle').click(toggleTask);
      $('.new-task').val('');
    });
  });
});
