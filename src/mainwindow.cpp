#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    _communicator = new Communicator(this);

    connect(ui->_startButton,&QPushButton::clicked,
            this,&MainWindow::startClickedSlot);
}

MainWindow::~MainWindow()
{
    delete _communicator;
    delete ui;
}

void MainWindow::startClickedSlot()
{
    _communicator->readCourseList();
}
