CREATE PROCEDURE [LMS].[uspGetCourseCurriculum](@BrandID int,@CourseID int=NULL)
as
begin

select TCM.I_Course_ID,TCM.S_Course_Name,TTM.I_Term_ID,TTM.S_Term_Name,
TMM.I_Module_ID,TMM.S_Module_Name,TSM.I_Session_ID,TSM.S_Session_Name,TESM.I_Skill_ID,TESM.S_Skill_Desc
from T_Course_Master TCM
inner join T_Term_Course_Map TTCM on TCM.I_Course_ID=TTCM.I_Course_ID
inner join T_Term_Master TTM on TTCM.I_Term_ID=TTM.I_Term_ID
inner join T_Module_Term_Map TMTM on TTM.I_Term_ID=TMTM.I_Term_ID
inner join T_Module_Master TMM on TMTM.I_Module_ID=TMM.I_Module_ID
inner join T_Session_Module_Map TSMM on TMM.I_Module_ID=TSMM.I_Module_ID
inner join T_Session_Master TSM on TSMM.I_Session_ID=TSM.I_Session_ID
inner join T_EOS_Skill_Master TESM on TESM.I_Skill_ID=TSM.I_Skill_ID
where
TCM.I_Status=1 and TTCM.I_Status=1 and TTM.I_Status=1 and TMTM.I_Status=1 and TMM.I_Status=1
and TSMM.I_Status=1 and TSM.I_Status=1 and TTCM.I_Course_ID=ISNULL(@CourseID,TCM.I_Course_ID)
and TCM.I_Brand_ID=@BrandID
and (TCM.I_Course_ID>=510 
		or TCM.I_Course_ID=363)
order by TCM.I_Course_ID,TTCM.I_Sequence,TMTM.I_Sequence,TSMM.I_Sequence

end
