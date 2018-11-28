--handles assigning bugs for verification ON INSERT
CREATE or REPLACE TRIGGER bugAssignment_insert
  AFTER UPDATE on squasher_user
  FOR EACH ROW
  WHEN(new.ASSIGNED = 'assigner')
DECLARE
  v_minAssigned NUMBER;
  v_Assignment VARCHAR(50);
BEGIN
  select MIN(NUM_ASSIGNED) into v_minAssigned from squasher_user where ROLE = 'TESTER';

  select username into v_Assignment from squasher_user where ROLE = 'TESTER' and NUM_ASSIGNED = v_minAssigned and ROWNUM <= 1 and USERNAME != 'assigner';

  update squasher_reports set ASSIGNED = v_Assignment where bug_id = :new.LATEST_ASSIGNED_BUG;
END;
/
show errors;
