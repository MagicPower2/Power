class App.TasksController extends App.ApplicationController
  @param 'title'

  @scope 'all'

  @beforeAction 'setContentType'
  setContentType: ->
    @headers['Content-Type'] = "application/json; charset=UTF-8"


  show: ->
    App.Project.find @params.projectId, (error, project) =>
      if error or project == null
          return @render json:{stat: 'fail', error: '404'}

      @project = project
      App.Task.find @params.id, (error, task) =>
        if error or task == null or task.projectId != @project.id
          return @render json:{stat: 'fail', error: '404'}
        @render json:{stat: 'ok', project: @project,  task: task}

  create: ->
    @task = App.Task.build(title: @params.title, status: 'todo')
    tasklistId = @params.tasklistId
    App.Project.find @params.projectId, (error, project) =>
      if error or project == null
        return @render json:{stat: 'fail', error: '404'}

      @task.set('tasklistId', tasklistId)
      @task.set('projectId', project.get('id'))
      @task.save (err) =>
        if err
          @render json:{stat: 'fail'}
        else
          @render json:{stat: 'ok', task: @task}
        

  destroy: ->
    console.log(@params)
    App.Task.find @params.id, (error, task) =>
      if error or task == null
        return @render json:{stat: 'fail', error: '404'}
      @task = task
      App.Project.find @params.projectId, (error, project) =>
        if error or project == null or @task.projectId != project.id
          return @render json:{stat: 'fail', error: '404'}

        @task.destroy (error) =>
          if error
            return @render json:{stat: 'fail'}
          return @render json:{stat: 'ok'}
        

  update: ->
    App.Task.find @params.id, (error, task) =>
      if error or task == null
        return @render json:{stat: 'fail', error: '404'}
      attrs = {}
      if @params.status != undefined
        if @params.status == 'done'
          status = 'done'
        else  
          status = 'todo'
        attrs['status'] = status
      if @params.title != undefined
        attrs['title'] = @params.title
      task.updateAttributes attrs, (error) =>
        if error
          return @render json:{stat: 'fail', error: 'save task error'}
        @render json:{stat: 'ok'}