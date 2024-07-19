--------------------------------------------------- DDL ----------------------------------------------------------
CREATE TABLE Accounts (
	UserID Nvarchar(50) NOT NULL PRIMARY KEY,
	Email Varchar(50) CONSTRAINT Ck_MAil CHECK (Email LIKE '%@%'),
	Name_First Varchar(20) NOT NULL,
	Name_Last Varchar(20) NOT NULL,
	Password Varchar(20) CONSTRAINT Ck_Password CHECK (len(Password) >= 6),
	BirthDate Date  NOT Null,
	Phone Char(10) CONSTRAINT Ck_Phone CHECK (Phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))


CREATE TABLE Channels (
	ChannelID Nvarchar(50) NOT NULL PRIMARY KEY,
	UserID Nvarchar(50) NOT NULL,
	Name Varchar(100) NOT NULL,
	
	Constraint Fk_User FOREIGN KEY (UserID)
						REFERENCES Accounts (UserID))



 CREATE TABLE Subscribes (
  UserID Nvarchar(50) NOT NULL,
  ChannelID Nvarchar(50) NOT NULL,
  DT DATETIME Not Null

  Constraint PK_subscribes PRIMARY KEY (UserID,ChannelID),
  Constraint Fk_User2 FOREIGN KEY (UserID)
						REFERENCES Accounts (UserID),
  Constraint Fk_Cnl FOREIGN KEY (ChannelID)
						REFERENCES Channels (ChannelID))



 CREATE TABLE Qualities (
	Quality Varchar(20) NOT NULL PRIMARY KEY)



 CREATE TABLE Videos (
	VideoID Nvarchar(50) NOT NULL PRIMARY KEY,
	Title Varchar(500) NoT NULL,
	Description Varchar(500) Null,
	Audience  Varchar(50) NOT NULL,
	Tags Varchar(150) NUll,
	Language Varchar(20) NUll,
	Subtitles Varchar(20) NUll,
	Visibility Varchar(20) NUll,
	PublishDate DATETIME NOT NULL,
	Quality Varchar(20) NOT NULL,
	Duration TIME NOT NULL,
	ChannelID Nvarchar(50) NOT NULL)



Create Table Searching
(
	DT_Searching DATETIME NOT NULL,
	KeyWords Varchar(500) NOT NULL,
	UserID Nvarchar(50) NOT NULL References Accounts(UserID) ,
	IP_Adderss Varchar(16) NOT NULL,
	Constraint PK_SEARCHING Primary Key (KeyWords,IP_Adderss ),
	Constraint CK_IP check (IP_Adderss Like ('%.%.%.%'))
)


 CREATE TABLE Retrives (
  KeyWords Varchar(500) NOT NULL,
  IP_Adderss Varchar(16) NOT NULL,
  VideoID Nvarchar(50) Not null

  Constraint PK_Retrives PRIMARY KEY (KeyWords, IP_Adderss, VideoID),
  Constraint Fk_Zoobi FOREIGN KEY (KeyWords,IP_Adderss)
						REFERENCES Searching (KeyWords,IP_Adderss),
  Constraint Fk_Vidr FOREIGN KEY (VideoID)
						REFERENCES Videos (VideoID))



 CREATE TABLE History (
	UserID Nvarchar(50) NOT NULL,
	VideoID Nvarchar(50) NOT NULL,
	DT DATETIME Not Null,
	Stopping_Point TIME Not Null,
	Watching_Quality Varchar(20)  NOt NUll,
	Speed Real Not Null,
	KeyWords Varchar(500) NOT NULL,
	IP_Adderss Varchar(16) NOT NULL

	Constraint PK_History PRIMARY KEY (UserID,DT),
	Constraint Fk_User3 FOREIGN KEY (UserID)
						REFERENCES Accounts (UserID),
	Constraint Fk_VID5 FOREIGN KEY (VideoID) 
						REFERENCES VIDEOS(VideoID),
	CONSTRAINT FK_qual2 FOREIGN KEY (Watching_Quality) 
						REFERENCES Qualities (Quality),
	CONSTRAINT FK_qual3 FOREIGN KEY (KeyWords, IP_Adderss) 
						REFERENCES Searching (KeyWords, IP_Adderss))


 ALTER TABLE Videos 
 ADD CONSTRAINT FK_qual FOREIGN KEY (Quality) 
						REFERENCES Qualities (Quality)
 

 CREATE TABLE Privacies (
	Privacy Varchar(20) NOT NULL PRIMARY KEY)
 
 
 CREATE TABLE Playlists (
	PlaylistID Nvarchar(50) NOT NULL PRIMARY KEY,
	Name Varchar(100) NOT NULL,
	Creation_DT DateTime NOT NULL,
	Privacy Varchar(20) NOT NULL,
	ChannelID Nvarchar(50) NOT NULL
	
	Constraint Fk_Cnl4 FOREIGN KEY (ChannelID)
						REFERENCES Channels (ChannelID),
	Constraint Fk_Prv2 FOREIGN KEY (Privacy)
						REFERENCES Privacies (Privacy))
 
 
 CREATE TABLE Saved (
	VideoID Nvarchar(50) NOT NULL,
	PlaylistID Nvarchar(50) NOT NULL, 
	Privacy Varchar(20) NOT NULL,
	Modified_DT DATETIME NOT NULL,

	Constraint PK_SAVED PRIMARY KEY (VideoID, PlaylistID),
	Constraint Fk_plst FOREIGN KEY (PlaylistID)
						REFERENCES Playlists (PlaylistID),
	Constraint Fk_VID FOREIGN KEY (VideoID)
						REFERENCES Videos (VideoID),
	Constraint Fk_Prv FOREIGN KEY (Privacy)
						REFERENCES Privacies (Privacy))



 Create Table LikeDislike (
	LikeDislike Varchar(10) NOT NULL PRIMARY KEY)



 CREATE TABLE Comments (
	VideoID Nvarchar(50) NOT NULL,
	UserID Nvarchar(50) NOT NULL,
	DT DATETIME NOT NULL,
	Content Varchar(500) NOT NULL,
	LikeDislike Varchar(10) Null,

	PRIMARY KEY (UserID, DT),
	Constraint Fk_VID2 FOREIGN KEY (VideoID)
						REFERENCES Videos (VideoID),
	Constraint Fk_User4 FOREIGN KEY (UserID)
						REFERENCES Accounts (UserID),
	Constraint FK_LDL FOREIGN KEY ( LikeDislike )
						REFERENCEs LikeDislike (LikeDislike))


 
 CREATE TABLE Reportings (
	ReporingtID Nvarchar(12) NOT NULL PRIMARY KEY,
	DT DATETIME NOT NULL,
	Reason Varchar(150) Null,
	UserID Nvarchar(50) NOT NULL,
	VideoID Nvarchar(50)  NULL

	Constraint Fk_VID3 FOREIGN KEY (VideoID)
						REFERENCES Videos (VideoID),
	Constraint Fk_User5 FOREIGN KEY (UserID)
						REFERENCES Accounts (UserID))

--------------------------------------------------- DML ----------------------------------------------------------
INSERT INTO Privacies
	VALUES ('Private'),
			('Unlisted'),
			('Public')


INSERT INTO Qualities
	VALUES ('2160p'),
			('1440p'),
			('1080p'),
			('720p'),
			('480p'),
			('360p'),
			('240p'),
			('144p')

INSERT INTO LikeDislike
	VALUES ('Like'),
			('Dislike')

--------------------------------------------------- Part 1 ----------------------------------------------------------
--Simple Query 1
Select c.ChannelID,c.Name, Numnew=count(DIstinct v.VideoID),countsearches=count(R.IP_Adderss)
From Channels as C join Videos as v on c.ChannelID=v.ChannelID Join Retrives as R on v.VideoID=r.VideoID
where Year(v.PublishDate)='2020'
Group by c.ChannelID,c.Name
Having count(R.IP_Adderss)>50
Order By countsearches desc

--Simple Query 2
select A.UserID, Name= a.Name_First+' '+a.Name_Last
From History as H join Videos as v on v.VideoID=H.VideoID Join Accounts as a on a.UserID=H.UserID
Where Title='Toyota'
Order By 1 desc

---Simple SubQuery 1
select a.UserID, Numchannels= count(Distinct z.channelID)
From accounts as a join Channels as c on c.UserID=a.UserID join(
Select c2.ChannelID
from channels as c2 join videos as V on v.ChannelID=c2.ChannelID 
Where Year(v.PublishDate)='2020'
Group By c2.ChannelID
)
as z on z.ChannelID=c.ChannelID
Group by a.UserID
Having count(Distinct z.channelID)>2
Order by 2 

---Simple SubQuery 2
Select v.VideoID, Title, NumSearches= count(distinct R.IP_Adderss)
From Videos as v join Retrives as r on v.VideoID=r.VideoID
Where Audience='Not Made for Kids'
Group by v.VideoID, Title
Having count(distinct R.IP_Adderss)>
(
Select avgviews= Cast(Count( r2.IP_Adderss)/count( distinct r2.VideoID) as decimal(10,3))
From  Retrives as r2 
)
order by NumSearches

---Extra SubQuery 1
Delete From Playlists
Where PlaylistID Not in
(
Select PlaylistID
From Saved
Group By PlaylistID
)

---Extra SubQuery 2
select UserID
From Comments
Group by UserID
having Count(*)>9
Intersect
(
select UserID
From Channels as c join(
Select ChannelID, videonum=Count(VideoID)
From Videos
Group By ChannelID
) as x on x.ChannelID=c.ChannelID
Group By UserID
having sum(Videonum)>9
)

--------------------------------------------------- Part 2 ----------------------------------------------------------

--View
create view Watchers as 
select DAY(h.DT) as 'Day in December 2020', COUNT(distinct h.UserID) as '# number of viewers'
from History h
where YEAR(h.DT) = 2020 and MONTH(h.DT) = 12 
group by DAY(h.DT)

-- Return the distribution of viewers by day (for the month of december) - who are the strongest days?
select *
from Watchers c
order by 2 desc

--Function 1
create function NumberViewed (@VID Nvarchar(50))
returns int
as		begin
		declare @Total int
		select @Total = COUNT(distinct h.UserID) 
		from History h
		where h.VideoID = @VID
		group by h.VideoID
		return @Total
		end

-- Return the most viewed videos
select v.Title, isnull(dbo.NumberViewed(v.VideoID), 0) as '# of Users viewed'
from Videos v
order by 2 desc


--Function 2
create function Mylist (@UID Nvarchar(50))
returns table
as		return
		select v.Title, v.Description, v.Language, v.Subtitles, v.Duration 
		from History h join Videos v on h.VideoID = v.VideoID
		where h.UserID = @UID

-- Return the list of videos a specific client has seen
select *
from dbo.Mylist('1Fouru')

--Trigger
create trigger Retrive 
on dbo.Searching for insert as
insert into dbo.Retrives
	select s.KeyWords, s.IP_Adderss, v.VideoID
	from Videos v join inserted s on v.Title=s.KeyWords


select *
from Retrives

--Stored Procedure
Create Procedure UpdateDescriptionVideo
@VideoID varchar(20) ,@new  Varchar(500)
as
Update Videos Set Description=@new
Where VideoID=@VideoID

Exec UpdateDescriptionVideo'0FVQuPCBseD','Chips'

select *
from Videos v
--------------------------------------------------- Part 3 ----------------------------------------------------------
--Additional Views
Create View Popularsearches as
Select  KeyWords, numsearches=Count(*)
From History
Group By keywords
Order By 2 desc

Create View byAudience as
Select  KeyWords,v.Audience, numsearches=Count(*)
From Retrives as r join Videos v on v.VideoID=r.VideoID
Group By keywords,v.Audience

Create View byChannel as
Select Top 10 KeyWords,v.ChannelID, numsearches=Count(*)
From Retrives as r join Videos v on v.VideoID=r.VideoID
Group By keywords,v.ChannelID

Create View byWK as
Select  KeyWords,v.Quality, numsearches=Count(*)
From Retrives as r join Videos v on v.VideoID=r.VideoID
Group By keywords,v.Quality

Create View sumviewsperchannelUser as
Select UserId,v.ChannelID, Numvids= Count(*)
From Channels as C join Videos v on v.ChannelID=c.ChannelID
Group By UserId,v.ChannelID

Create View ReportingsperchannelUser as
Select c.UserID,v.ChannelID, Numvids= Count(ReporingtID)
From Channels as C join Videos v on v.ChannelID=c.ChannelID Join Reportings r on r.VideoID=v.VideoID
Group By c.UserID,v.ChannelID

Create View sumhistoryuperchannelUser as
Select  Top 10 c.UserID,v.ChannelID, Numvids= Count(*)
From Channels as C join Videos v on v.ChannelID=c.ChannelID join History h on h.VideoID=v.VideoID
Group By c.UserID,v.ChannelID


--------------------------------------------------- Part 4 ----------------------------------------------------------
--SP --> Function --> Trigger (+Cursor)
ALTER TABLE Accounts
ADD Score int

ALTER TABLE Accounts
add S Varchar(10)



create trigger Update_Status 
on Accounts for update as

declare @uid Varchar
declare @score int
declare @s Varchar(10)
declare d cursor 
			for select UserID, Score, S from Accounts 
			for update  
  
open d
fetch next from d into @uid, @score, @s;

while (@@FETCH_STATUS = 0)
begin
	if (@score > 10) set @s = 'active'
				else set @s = 'regular' 
	--print @s
	update Accounts
	set Accounts.S = @s
	from Accounts
	where current of d
	
	fetch next from d into @uid, @score, @s
end
close d
deallocate d


create function myScore (@UID Nvarchar(50), @Year int, @MONTH int)
returns int
as		begin
		declare @Score int
		select @Score = 
			(select COUNT(c.Content)
				from Comments c
				where UserID = @UID and YEAR(c.DT) = @Year and MONTH(c.DT) = @MONTH) * 3
			+
			(select COUNT(r.ReporingtID)
				from Reportings r
				where UserID = @UID and YEAR(r.DT) = @Year and MONTH(r.DT) = @MONTH) * 2
		return @Score
		end


create procedure AllScores @Year int, @MONTH int
as begin
	Update Accounts set Score = dbo.myScore(Accounts.UserID, @Year, @MONTH)
	end
	
exec AllScores 2020, 7

--Advanced Report
Create Function AvgViewsCnl2(@CnlID varchar(20))
Returns Real
As Begin
Declare @AverageViews real
Select @AverageViews=(case when count(Distinct v.VideoID)=0 then 0 Else Count( IP_Adderss)/count(Distinct h.VideoID) eND)
From History AS H JOIN Videos as v on v.VideoID= h.VideoID
Where h.VideoID in
(Select VideoID
From Videos
where ChannelID=@CnlID
)
Return @AverageViews
END


Create Function Net2(@CnlID varchar(20))
Returns int
As Begin
Declare @Net int
Select @Net=(Case When Count(*)=0 Then 0 Else
(Select Count(c.Content)
From Comments AS c JOIN Videos as v on v.VideoID= C.VideoID
Where c.VideoID in
(Select VideoID
From Videos
where ChannelID=@CnlID
) and  LikeDislike='Like'
Group By ChannelID
)
-(Select Count(c.Content)
From Comments AS c JOIN Videos as v on v.VideoID= C.VideoID
Where c.VideoID in
(Select VideoID
From Videos
where ChannelID=@CnlID
) and  LikeDislike='DisLike'
Group By ChannelID
)End)
Return @Net
END

select *
from Accounts


select accounts.UserID, Name=Accounts.Name_First+' '+ Accounts.Name_Last, AverageViews=(case when Sum(dbo.AvgViewsCnl2(ChannelID))=0 then 0 Else Sum(dbo.AvgViewsCnl2(ChannelID))/count(Distinct ChannelID) eND)
, NetInteractions=sum(case when dbo.Net2(channelID) is null then 0 Else dbo.Net2(ChannelID) end)
From Channels join Accounts on Channels.UserID= Accounts.UserID
Group By accounts.UserID,Name_First,Name_Last
Having (Sum(dbo.AvgViewsCnl2(ChannelID))>0) 
Order By AverageViews desc	