load('application');
before(loadProjectTasks, {only: [ 'show']});



action(function index() {
    Project.all(function (err, projects) {
        res.json(projects);
    });
});

var step = require('step');

action(function show() {
    this.title = 'Project show';
    
    var p = this.project;
    // TaskList.all({where:{projectId:params.id}}, function(err, tasklists){
    //     console.log(typeof(tasklists));
    //     console.log(tasklists);
    //     var list = [];
    //     tasklists.forEach(function(tasklist){
    //         tasklist.tasks(function(err, tasks){
    //             if(tasks.length>0){
    //                 console.log(tasks);
    //                 tasklist.tasks = tasks;
    //             }
    //             list.push(tasklist);
    //         });
    //     });
       

    // });
    
    step(
        function thefunc1(finishFlag){
        console.log("func1");
      },
      function thefunc2(finishFlag){
        console.log("finishFlag2");
      },
      function thefunc3(finishFlag){
        console.log("finishFlag3");
      }

        // function fun1(){
        //     Project.find(params.id, function (err, data) {
        //         if (err || !data) {
        //             res.json({stat:'error', error:err})
        //         } else {
        //             console.log(data);
        //             this.project = data;
        //             next();
        //         }
        //     }.bind(this));
        // },

        // function fun2(){
        //     console.log('func2');
        // },

        // function fun3(){
        //     console.log('func3');
        // },
    );

    res.json({project: this.project,  
        tasklists: this.tasklists, test:'ok'});

});

function loadProjectTasks() {
    Project.find(params.id, function (err, data) {
        if (err || !data) {
            res.json({stat:'error', error:err})
        } else {
            console.log(data);
            this.project = data;
            this.project.tasklists(function(err, tasklists){
                var list = [];
                tasklists.forEach(function(tasklist){
                    tasklist.tasks(function(err, tasks){
                        if(tasks.length>0){
                            console.log(tasks);
                            tasklist.tasks = tasks;
                        }
                        list.push(tasklist);
                        this.tasklists = tasklists;
                        next();
                    });
                });
            });
        }
    }.bind(this));

    // TaskList.all({where:{projectId:params.id}}, function(err, tasklists){
    //     var list = [];

    //     tasklists.forEach(function(tasklist){
    //         tasklist.tasks(function(err, tasks){
    //             if(tasks.length>0){
    //                 console.log(tasks);
    //                 tasklist.tasks = tasks;
    //             }
    //             list.push(tasklist);
    //             this.tasklists = tasklists;
    //             next();
    //         });
    //     });
        

    //     next();
    // });
}

function loadProject() {
    Project.find(params.id, function (err, data) {
        if (err || !data) {
            res.json({stat:'error', error:err})
        } else {
            console.log(data);
            this.project = data;
            next();
        }
    }.bind(this));
}

