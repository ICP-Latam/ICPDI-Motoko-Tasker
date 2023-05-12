import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import Nat32 "mo:base/Nat32";
import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Bool "mo:base/Bool";
import Iter "mo:base/Iter";

actor ElTasker {

  type TaskId = Nat32;

  type Task = {
    description: Text;
    status: Bool;
  };
  type Tasklist = HashMap.HashMap<Text, Task>;

  private stable var nextTaskId : TaskId = 0;

  let UserTasklist = HashMap.HashMap<Principal, Tasklist>(0, Principal.equal, Principal.hash);
  
  private func generateTaskId() : TaskId {
    nextTaskId += 1;
    return nextTaskId;
  };

public shared (msg) func createUserTask(description: Text) : async Task {
    let user : Principal = msg.caller;
    var NewTask: Task = {description=description; status= false};

    let UserTasks = UserTasklist.get(user);

    var TheUserTasks : Tasklist = switch UserTasks {
      case (null) {
        HashMap.HashMap(0, Text.equal, Text.hash);
      };
      case (?UserTasks) UserTasks;
    };

    TheUserTasks.put(Nat32.toText(generateTaskId()), NewTask);

    UserTasklist.put(user, TheUserTasks);

    Debug.print("New Task created!" # Principal.toText(user));
    return NewTask;
  };

  public query (msg) func getTaskById(TaskId: Text) : async Task {
    let user : Principal = msg.caller;
    let resultUserTasklist = UserTasklist.get(user);

    var TheUserTaskList: Tasklist = switch resultUserTasklist {
      case (null) {
        HashMap.HashMap(0, Text.equal, Text.hash);
      };
      case (?resultUserTasklist) resultUserTasklist;
    };

    let FoundTask = TheUserTaskList.get(TaskId);

    var TheTask : Task = switch FoundTask {
      case (null) {
        {
          description = "Not found";
          status = false;
        };
      };
      case (?FoundTask) FoundTask;
    };

    return TheTask;
  };

  public query (msg) func getUserTaks() : async [(Text, Task)] {
    let user : Principal = msg.caller;
    let resultUserTasklist = UserTasklist.get(user);

    var TheUserTaskList: Tasklist = switch resultUserTasklist {
      case (null) {
        HashMap.HashMap(0, Text.equal, Text.hash);
      };
      case (?resultUserTasklist) resultUserTasklist;
    };

    return Iter.toArray<(Text, Task)>(TheUserTaskList.entries());
  };

   public shared (msg) func UpdateTask(TaskId: Text) : async Task {
    let user : Principal = msg.caller;
    let resultUserTasklist = UserTasklist.get(user);

    var TheUserTaskList: Tasklist = switch resultUserTasklist {
      case (null) {
        HashMap.HashMap(0, Text.equal, Text.hash);
      };
      case (?resultUserTasklist) resultUserTasklist;
    };

    let FoundTask = TheUserTaskList.get(TaskId);

    let TheTask : Task = switch FoundTask {
      case (null) {
        {
          description = "Not found";
          status = false;
        };
      };
      case (?FoundTask) FoundTask;
    };
    var NewTask: Task = {description=TheTask.description; status=true};
    TheUserTaskList.put(TaskId, NewTask);
    Debug.print("Task "# TaskId #" Updated!" # Principal.toText(user));
    return NewTask;
  };

}



