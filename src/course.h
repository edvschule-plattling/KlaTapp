#ifndef COURSE_H
#define COURSE_H

#include <QString>

class Course
{
 public:
    Course();

 private:
    int     _id = 0;
    QString _bezeichnung;
    QString _alias;

};

#endif // COURSE_H
