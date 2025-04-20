using { emp.db as db } from '../db/emp-db';

service EmployeeDirectory @(path: '/emp-directory') {

    entity Employee as projection on db.Employee;
    entity Address as projection on db.Address;
    entity Project as projection on db.Project;

    // @cds.redirection.target
    // entity Managers as projection on db.Employee as m {
    //     m.fullName,
    //     m.jobTitle,
    //     m.project,
    //     m.department,
    //     m.location,
    //     m.status
    // } where m.isManager = true;

    entity Managers @cds.redirection.target as select from db.Employee as m {
        *
    } where m.isManager = true;
    
    action separateEmployee(employeeID: UUID) returns String;
    function getProjectDetails(projectID: UUID) returns array of Project;

}