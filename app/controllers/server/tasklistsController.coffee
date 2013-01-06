class App.TasklistsController extends App.ApplicationController
  @param 'title'
  @param 'projectId', exact: true
  @scope 'all'

  @beforeAction 'setContentType'
  setContentType: ->
    @headers['Content-Type'] = "application/json; charset=UTF-8"


  create: ->
    @tasklist = App.Tasklist.build(title: @params.title)
    App.Project.find @params.projectId, (error, project) =>
      if error or project == null
        return @render text:{stat: '404', error: 'project not found'}

      @tasklist.set('projectId', project.get('id'))
      @tasklist.save (error) =>
        if error
          @render json:{stat: 'fail', error: error}
        else
          @render json:{stat: 'ok', tasklist: @tasklist}
        

  show: ->
    App.Project.find @params.projectId, (error, project) =>
      if error or project == null
        return @render json:{stat: '404', error: 'project not found'}

      @project = project
      App.Tasklist.find @params.id, (error, tasklist) =>
        if error or tasklist == null
          return @render json:{stat: '404', error: 'tasklist not found'}
        console.log("tasklist ", tasklist)
        @tasklist = tasklist
        App.Task.where(tasklistId: @params.id).all (error, tasks) =>
          if error
            @render json:{stat: '404', error: 'task not found'}

          json_data = @tasklist.toJSON()
          console.log(tasks)
          json_tasks = []
          for t in tasks
            console.log(t.toJSON())
            json_tasks.push(t.toJSON())

          json_data['tasks'] = json_tasks
          @render json:{stat: 'ok', project:_this.project, tasklist: json_data}



  update: ->
    App.Tasklist.find @params.id, (error, tasklist) =>
      if error or tasklist == null
        return @render json:{stat: '404', error: 'tasklist not found'}
      attrs = {}

      if @params.title != undefined
        attrs['title'] = @params.title
      tasklist.updateAttributes attrs, (error) =>
        if error
          return @render json:{stat: 'fail', error: error}
        @render json:{stat: 'ok'}

  destroy: ->
    console.log(@params)
    App.Tasklist.find @params.id, (error, tasklist) =>
      if error or tasklist == null
        return @render json:{stat: '404', error: 'tasklist not found'}
      @tasklist = tasklist
      App.Project.find @params.projectId, (error, project) =>
        if error or project == null or @tasklist.get('projectId').toString() != project.get('id').toString()
          return @render json:{stat: '404', error: 'project not found'}

        @tasklist.destroy (error) =>
          if error
            return @render json:{stat: 'fail', error: error}
          return @render json:{stat: 'ok'}