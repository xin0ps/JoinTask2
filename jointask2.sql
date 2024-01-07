--11. To deduce the most popular subjects (and) among students and teachers.
--11. Student və Teacherlər arasında ən məşhur mövzunu(ları) çıxarın.

SELECT TOP(1) WITH TIES T.Name, ThemeCount
FROM Themes T
LEFT JOIN (
    SELECT Books.Id_Themes, COUNT(*) AS ThemeCount
    FROM Books
    LEFT JOIN S_Cards ON S_Cards.Id_Book = Books.Id
    LEFT JOIN T_Cards ON T_Cards.Id_Book = Books.Id
    WHERE S_Cards.Id_Book IS NOT NULL OR T_Cards.Id_Book IS NOT NULL
    GROUP BY Books.Id_Themes
) B ON T.Id = B.Id_Themes
GROUP BY T.Name, B.ThemeCount ORDER BY ThemeCount DESC


--12. Display the number of teachers and students who visited the library.
--12. Kitabxanaya neçə tələbə və neçə müəllim gəldiyini ekrana çıxarın.

SELECT DISTINCT Students.FirstName, COUNT(Students.FirstName) AS [Visit] FROM Students INNER JOIN S_Cards ON S_Cards.Id_Student = Students.Id
GROUP BY (FirstName) UNION ALL (
SELECT DISTINCT Teachers.FirstName, COUNT(Teachers.FirstName) FROM Teachers INNER JOIN T_Cards ON T_Cards.Id_Teacher = Teachers.Id GROUP BY Teachers.FirstName)

	
--15. Show the author (s) of the most popular books among teachers and students.
--15. Tələbələr və müəllimlər arasında ən məşhur authoru çıxarın.

SELECT TOP (1) WITH TIES A.FirstName FROM Books B INNER JOIN 
(SELECT C.Name, COUNT(*) AS [CountKitab] FROM Books C INNER JOIN T_Cards ON T_Cards.Id_Book = C.Id GROUP BY C.Name) Z ON B.Name = Z.Name
INNER JOIN 
(SELECT C.Name, COUNT(*) AS [CountKitab] FROM Books C INNER JOIN S_Cards ON S_Cards.Id_Book = C.Id GROUP BY C.Name) X ON B.Name = X.Name
FULL JOIN 
Authors A ON A.Id = B.Id_Author
GROUP BY A.FirstName, (Z.CountKitab + X.CountKitab) ORDER BY (Z.CountKitab + X.CountKitab) DESC

--16. Display the names of the most popular books among teachers and students.
--16. Müəllim və Tələbələr arasında ən məşhur kitabların adlarını çıxarın.

SELECT TOP (1) WITH TIES B.Name, Z.CountKitab + X.CountKitab AS [Countall] FROM Books B INNER JOIN 
(SELECT C.Name, COUNT(*) AS [CountKitab] FROM Books C INNER JOIN T_Cards ON T_Cards.Id_Book = C.Id GROUP BY C.Name) Z ON B.Name = Z.Name
INNER JOIN 
(SELECT C.Name, COUNT(*) AS [CountKitab] FROM Books C INNER JOIN S_Cards ON S_Cards.Id_Book = C.Id GROUP BY C.Name) X ON B.Name = X.Name
GROUP BY B.Name, Z.CountKitab + X.CountKitab ORDER BY [Countall] DESC

--17. Show all students and teachers of designers.
--17. Dizayn sahəsində olan bütün tələbə və müəllimləri ekrana çıxarın.

SELECT Teachers.FirstName + ' ' + Teachers.LastName AS [AD Soyad] FROM Teachers INNER JOIN Departments ON 
(SELECT D.Id FROM Departments D WHERE D.Name LIKE '%Design%') = Teachers.Id_Dep GROUP BY Teachers.FirstName, Teachers.LastName
UNION ALL SELECT S.FirstName + ' ' + S.LastName FROM Students S INNER JOIN Groups ON Groups.Id = S.Id_Group INNER JOIN Faculties ON (SELECT DISTINCT F.Id FROM Faculties F WHERE F.Name LIKE '%Design%') = Groups.Id_Faculty GROUP BY S.FirstName, S.LastName

--18. Show all information about students and teachers who have taken books.
--18. Kitab götürən tələbə və müəllimlər haqqında informasiya çıxarın.

SELECT DISTINCT Students.FirstName + ' ' + Students.LastName AS [Ad soyad] FROM Students INNER JOIN S_Cards ON S_Cards.Id_Student = Students.Id GROUP BY Students.FirstName, Students.LastName 
UNION ALL SELECT DISTINCT Teachers.FirstName + ' '+ Teachers.LastName FROM Teachers INNER JOIN T_Cards ON T_Cards.Id_Teacher = Teachers.Id GROUP BY Teachers.FirstName, Teachers.LastName

--19. Show books that were taken by both teachers and students.
--19. Müəllim və şagirdlərin cəmi neçə kitab götürdüyünü ekrana çıxarın. -- Sehv translation

SELECT DISTINCT Books.Name FROM Books INNER JOIN S_Cards ON S_Cards.Id_Book = Books.Id 
INNER JOIN T_Cards ON T_Cards.Id_Book = Books.Id GROUP BY Books.Name

--20. Show how many books each librarian issued.
--20. Hər kitbxanaçının (libs) neçə kitab verdiyini ekrana çıxarın

SELECT DISTINCT Libs.FirstName, B.LibCount + C.LibCount AS [Verilmis kitab sayi] FROM Libs LEFT JOIN (SELECT DISTINCT Libs.Id, COUNT(*) AS [LibCount] FROM S_Cards 
INNER JOIN Libs ON S_Cards.Id_Lib = Libs.Id GROUP BY Libs.Id) B ON Libs.Id = B.Id LEFT JOIN (SELECT DISTINCT Libs.Id, 
COUNT(*) AS [LibCount] FROM T_Cards 
INNER JOIN Libs ON T_Cards.Id_Lib = Libs.Id GROUP BY Libs.Id) C ON Libs.Id = C.Id GROUP BY Libs.FirstName, B.LibCount, C.LibCount