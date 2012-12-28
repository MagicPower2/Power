class App.ProjectsController extends App.ApplicationController
  @param 'title'

  @scope 'all'

  Step = require('step')

  @beforeAction 'setContentType' #, only: ['show', 'index', 'create', 'destroy']
  setContentType: ->
    @headers['Content-Type'] = "application/json; charset=UTF-8"

  # loadProject: ->
  #   App.Project.find @params.id, (error, project) =>
  #     if error or project == null
  #       return @render json:{stat: 'fail', error: '404'}
  #     @project = project

  index: ->
    App.Project.all (err, projects) =>
      if err
        @render json:{stat: 'fail'}
      else
        @render json:{stat: 'ok', projects:projects}
        


  create: ->
    console.log(@params)
    @project = App.Project.build(title: @params.title)

    @project.save (error) =>
      if error
        @render json:{stat: 'fail'}
      else
        @render json:{stat: 'ok', project: @project}
        
  destroy: ->
    App.Project.find @params.id, (error, project) =>
      if error or project == null
        return @render json:{stat: 'fail'}
      App.Tasklist.where(projectId: @params.id).destroy (error) =>
        console.log("destroy tasklist", error)
      App.Task.where(projectId: @params.id).destroy (error) =>
        console.log("destroy task", error)
      project.destroy (error) =>
        if error
          @render json:{stat: 'fail'}
        else
          @render json:{stat: 'ok', project: project}


  show: ->
    _this = this
    projectId = @params.id
    tasklists = {}
  
    App.Project.find projectId, (err, project) =>
      if err or project == null
        return @render json:{stat: 'fail', error: '404'}
      else
        @project = project

      Step(
        ->
          App.Tasklist.where(projectId: projectId).all this
          return
        (err, tls)->
          if err
            return []
          # console.log("tasklist count is: ", tls.length)
          parallel = this.parallel
          if tls.length>0 
            for tasklist in tls
              tasklistId = tasklist.get('id')
              # console.log(tasklist.get('title'), tasklistId)
              tasklists[tasklistId] = tasklist.toJSON()
              App.Task.where(tasklistId: tasklistId).all   parallel()
            return
          else
            return []
        (err)->
          # console.log("arguments: ", Array.prototype.slice.call(arguments,1))
          
          for data in Array.prototype.slice.call(arguments,1)
            # console.log("task tasklistId: ", data[0].get('tasklistId'), tasklists)
            if data != undefined and data.length > 0
              tasklistId = data[0].get('tasklistId')
              if tasklistId != undefined
                tasks = []
                for tl in data
                  tasks.push(tl.toJSON())
                if tasks.length > 0
                  tasklists[tasklistId]['tasks'] = tasks

          
          json_data = {project: {id: projectId}, tasklists: tasklists}        
          
          _this.render json: {project: _this.project, tasklists: tasklists}  , status: 200
      )
    
    return
