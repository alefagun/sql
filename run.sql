Set Pages 1000
Set head on

Column Manager   Format A20
Column Request   Format 9999999999
Column Program   Format A35
Column User_Name Format A15
Column Started   Format A15

Select Concurrent_Queue_Name Manager,
       Request_Id Request, User_name,
       Concurrent_Program_Name Program, Run_Alone_Flag,
       To_Char(Actual_Start_Date, 'DD-MON-YY HH24:MI') Started
  from Fnd_Concurrent_Queues Fcq, Fnd_Concurrent_Requests Fcr,
       Fnd_Concurrent_Programs Fcp, Fnd_User Fu, Fnd_Concurrent_Processes Fpro
 where
       Phase_Code = 'R' And
       Fcr.Controlling_Manager = Concurrent_Process_Id       And
      (Fcq.Concurrent_Queue_Id = Fpro.Concurrent_Queue_Id    And
       Fcq.Application_Id      = Fpro.Queue_Application_Id ) And
       (Fcr.Concurrent_Program_Id = Fcp.Concurrent_Program_Id And
       Fcr.Program_Application_Id = Fcp.Application_Id )     And
       Fcr.Requested_By = User_Id
;
