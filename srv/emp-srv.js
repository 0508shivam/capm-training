const cds = require('@sap/cds');

module.exports = cds.service.impl(async (srv) => {

    const { Employee, Project } = srv.entities;

    // Updating the request with FullName of the Employee using the first and last Name
    srv.before('CREATE', Employee, async (req) => {

        console.log('Before Insert Authors', req.data);
        const {  firstName, lastName } = req.data;

        req.data.fullName = `${firstName} ${lastName}`;

    });


    //Implementation for separateEmployee action
    srv.on('separateEmployee', async (req) => {
        
        const { employeeID } = req.data;
        const tx = cds.transaction(req);

        try {
            
            //Checking if the employee Id exists
            const employeeData = await tx.run(
                SELECT.one.from(Employee)
                  .where({'ID': employeeID})
              );

            if(!employeeData){
                throw new Error('Employee not found');
            }

            //Update the Employee with status => inactive
            await tx.run(
                UPDATE(Employee)
                .set({ status_code: false })
                .where({ID: employeeID})
            );
        
            return `Employee with ID ${employeeID} is separated successfully!`;

        } catch (error) {
            // Send a 500 Internal Server Error response with the error message
            req.error(500, error.message);
        }

    });

    //Implementing getProjectDetails function
    srv.on('getProjectDetails', async (req) => {

        const { projectID } = req.data;
        const tx = cds.transaction(req);

        console.log(projectID);
        try {

            const projectDetails = await tx.run(
                SELECT.from(Project)
                  .where({ ID: projectID })
            );

            if (!projectDetails) {
                throw new Error('Project not found');
            } else {
                return projectDetails;
            }

        } catch(error) {
            req.error(500, error.message);
        }

    });


});
