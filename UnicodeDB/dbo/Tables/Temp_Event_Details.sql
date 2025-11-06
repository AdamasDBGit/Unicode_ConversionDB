CREATE TABLE [dbo].[Temp_Event_Details] (
    [event_id]          INT            NULL,
    [event_description] NVARCHAR (MAX) NULL,
    [event_start_date]  DATE           NULL,
    [event_end_date]    DATE           NULL,
    [event_category]    NVARCHAR (50)  NULL,
    [event_start_time]  TIME (7)       NULL,
    [event_end_time]    TIME (7)       NULL,
    [event_location]    NVARCHAR (255) NULL,
    [event_type]        NVARCHAR (50)  NULL,
    [rsvp_link]         NVARCHAR (MAX) NULL
);

