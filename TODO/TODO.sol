//SPDX-License-Identifier:MIT
pragma solidity ^0.8.7;
interface IFavourited {
    function IsFavourited(uint16 _id) external;
}
interface ICompleted {
    function IsCompleted(uint16 _id) external;
    function getCompletedTask(uint16 _id) external returns(bool);

}
contract TODO is IFavourited,ICompleted {
    address _owner;
    enum isFavourite {YES,NO}
    struct Task {
        uint id;
        string text;
        uint creationTime;
        bool completed;
        isFavourite favorated;
   }
    mapping(address=>mapping(uint=>Task)) tasks;
    modifier onlyowner{
        require(msg.sender==_owner,"UNAUTHORIZED USER");
        _;
    }
    constructor(){
        _owner = msg.sender;

    }
    event createdTask(uint16 id,string _text,uint _creationTime);
    event deletedTask(string _text);
    event editEvent(string _text);
    event favouratedTask(string _text);

    function createTask(string memory _text,uint16 id) external{
        Task memory task = Task(id,_text,block.timestamp,false,isFavourite.NO);
        tasks[_owner][id] = task;
        emit createdTask(id,_text,block.timestamp);
    }
    function editTask(string memory _text,uint _id) external {
        tasks[_owner][_id].text=_text;
        emit editEvent(_text);
    }
    function getTask(uint16 _id) external view onlyowner returns(string memory){
        return tasks[_owner][_id].text;
    }
    function deleteTask(uint16 _id) external onlyowner {
        emit deletedTask(tasks[_owner][_id].text);
        delete tasks[_owner][_id];
    }
    function IsFavourited(uint16 _id) external override onlyowner {
        Task storage task = tasks[_owner][_id];
        task.favorated = isFavourite.YES;
        emit favouratedTask(task.text);
    }
    function getFavorited(uint16 _id) external view onlyowner returns(isFavourite){
        return tasks[_owner][_id].favorated;
    }
    function IsCompleted(uint16 _id) external override onlyowner{
        Task storage task = tasks[_owner][_id];
        task.completed = true;
    }
    function getCompletedTask(uint16 _id) external view override onlyowner returns(bool) {
        return tasks[_owner][_id].completed;
    }

}
