update dbo.USERS set PASSWORD = '$2b$12$qH1tbkrZN7af4P0hL3AfxeLH4ETdxjMd7Gh1lrniXbek4PcfJ99qi'
 where USER_NAME = 'admin';
 update dbo.USERS set PASSWORD = '$2b$12$AkOh2nhG2RpxBqmKlrXtMOmpftDWhoy76g2bR1kOvN4iJ2bYIloNy'
 where USER_NAME = 'creator';
 update dbo.USERS set PASSWORD = '$2b$12$ZH0mLtYmjmolMERawFJnk.O/7n8U8bLhZ0rsyRtKynSfiptTj2VW6'
 where USER_NAME = 'guest';