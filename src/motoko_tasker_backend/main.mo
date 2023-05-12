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
  //set of types
  type TaskId = Nat32;
  type Task = {
    description: Text;
    status: Bool;
  };

  //set every task with the id
  type Tasklist = HashMap.HashMap<Text, Task>;

  //id initialization
  private stable var nextTaskId : TaskId = 0;

  //set storage data for user with the tasklist
  let UserTasklist = HashMap.HashMap<Principal, Tasklist>(0, Principal.equal, Principal.hash);
  
  //function to get the next TaskId
  private func generateTaskId() : TaskId {
    nextTaskId += 1;
    return nextTaskId;
  };

  //function to create a new task with a given description, is bendend to the tasklist of the user
  public shared (msg) func createUserTask(description: Text) : async Task {
    //construction of the values to put
    let user : Principal = msg.caller;
    var NewTask: Task = {description=description; status= false};
    //get tasklist for the user
    let UserTasks = UserTasklist.get(user);
    //check if the tasklist is null to avoid errors
    var TheUserTasks : Tasklist = switch UserTasks {
      case (null) {
        HashMap.HashMap(0, Text.equal, Text.hash);
      };
      case (?UserTasks) UserTasks;
    };
    //generate the new task for the user
    TheUserTasks.put(Nat32.toText(generateTaskId()), NewTask);
    
    //set/update the tasklist for the user
    UserTasklist.put(user, TheUserTasks);

    Debug.print("New Task created!" # Principal.toText(user));

    return NewTask;
  };

  //Function to search a task by a given id in text
  public query (msg) func getTaskById(TaskId: Text) : async Task {
    //construction of the values to use
    let user : Principal = msg.caller;
    let resultUserTasklist = UserTasklist.get(user);
    //get tasklist for the user and check nulls
    var TheUserTaskList: Tasklist = switch resultUserTasklist {
      case (null) {
        HashMap.HashMap(0, Text.equal, Text.hash);
      };
      case (?resultUserTasklist) resultUserTasklist;
    };

    let FoundTask = TheUserTaskList.get(TaskId);
    //search the task, but if null return a not found
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

  //Function to search all tasks of the user
  public query (msg) func getUserTaks() : async [(Text, Task)] {
    //construction of the values to use
    let user : Principal = msg.caller;
    let resultUserTasklist = UserTasklist.get(user);
    //get tasklist for the user and check nulls
    var TheUserTaskList: Tasklist = switch resultUserTasklist {
      case (null) {
        HashMap.HashMap(0, Text.equal, Text.hash);
      };
      case (?resultUserTasklist) resultUserTasklist;
    };
    //here is a coverto to array using a Iter for return every id with the task values
    return Iter.toArray<(Text, Task)>(TheUserTaskList.entries());
  };
  //Function to update the status of a task by a given id
  public shared (msg) func UpdateTask(TaskId: Text) : async Task {
    let user : Principal = msg.caller;
    let resultUserTasklist = UserTasklist.get(user);
    //get tasklist for the user and check nulls
    var TheUserTaskList: Tasklist = switch resultUserTasklist {
      case (null) {
        HashMap.HashMap(0, Text.equal, Text.hash);
      };
      case (?resultUserTasklist) resultUserTasklist;
    };

    let FoundTask = TheUserTaskList.get(TaskId);
    //search the task, but if null return a not found
    let TheTask : Task = switch FoundTask {
      case (null) {
        {
          description = "Not found";
          status = false;
        };
      };
      case (?FoundTask) FoundTask;
    };
    //here we set the status of true
    var NewTask: Task = {description=TheTask.description; status=true};
    //and finally the update of the value by the key
    TheUserTaskList.put(TaskId, NewTask);
    Debug.print("Task "# TaskId #" Updated!" # Principal.toText(user));
    return NewTask;
  };

}


