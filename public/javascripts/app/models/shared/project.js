var __hasProp = {}.hasOwnProperty,
  __extends =   function(child, parent) {
    if (typeof parent.__extend == 'function') return parent.__extend(child);
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } 
    function ctor() { this.constructor = child; } 
    ctor.prototype = parent.prototype; 
    child.prototype = new ctor; 
    child.__super__ = parent.prototype; 
    if (typeof parent.extended == 'function') parent.extended(child); 
    return child; 
};

App.Project = (function(_super) {
  var Project;

  function Project() {
    return Project.__super__.constructor.apply(this, arguments);
  }

  Project = __extends(Project, _super);

  Project.field('title', {
    type: 'String'
  });

  Project.hasMany('tasklists');

  Project.hasMany('tasks');

  Project.timestamps();

  Project.belongTo('master', {
    type: 'User'
  });

  Project.hasMany('users');

  return Project;

})(Tower.Model);
