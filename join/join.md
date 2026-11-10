# Join - Štěpán Hodboď 3IT

## uloha 1
``` sql
SELECT books.title, authors.first_name, authors.last_name
FROM books
INNER JOIN authors ON books.author_id = authors.author_id;
```
![Fotka k uloze 1](foto/image-3.png)

## Uloha 2
```sql
SELECT authors.first_name, authors.last_name, books.title 
FROM authors 
LEFT JOIN books ON authors.author_id = books.author_id;
```
![Fotka k uloze 2](foto/image-2.png)
## uloha 3
```sql
SELECT loans.student_name, books.title 
FROM loans 
INNER JOIN books ON loans.book_id = books.book_id;
```
![Fotka k uloze 3](foto/image-1.png)
## uloha 4
```sql
SELECT books.title, loans.student_name 
FROM books 
LEFT JOIN loans ON loans.book_id = books.book_id;
```
![Fotka k uloze 4](foto/image-4.png)

## uloha 5
```sql
SELECT authors.first_name, authors.last_name, books.title
FROM books
RIGHT JOIN authors ON authors.author_id = books.author_id;
```
![Fotka k uloze 5](foto/image-5.png)