# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file '.\ui_section_parameters.ui'
#
# Created by: PyQt5 UI code generator 5.13.0
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_SectionParameters(QtWidgets.QDialog):
    def __init__(self,index_type,index_template):
        super().__init__()
        self.setObjectName("Dialog")
        self.setWindowModality(QtCore.Qt.NonModal)
        self.resize(319, 300)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Preferred, QtWidgets.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.sizePolicy().hasHeightForWidth())
        self.setSizePolicy(sizePolicy)
        self.setMinimumSize(QtCore.QSize(0, 300))
        self.setMaximumSize(QtCore.QSize(100000, 300))
        self.setModal(True)
        self.verticalLayout_3 = QtWidgets.QVBoxLayout(self)
        self.verticalLayout_3.setObjectName("verticalLayout_3")
        self.horizontalLayout = QtWidgets.QHBoxLayout()
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.verticalLayout = QtWidgets.QVBoxLayout()
        self.verticalLayout.setObjectName("verticalLayout")
        self.parameterLabel_1 = QtWidgets.QLabel(self)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.parameterLabel_1.setFont(font)
        self.parameterLabel_1.setObjectName("parameterLabel_1")
        self.verticalLayout.addWidget(self.parameterLabel_1)
        self.parameterLabel_2 = QtWidgets.QLabel(self)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.parameterLabel_2.setFont(font)
        self.parameterLabel_2.setObjectName("parameterLabel_2")
        self.verticalLayout.addWidget(self.parameterLabel_2)
        self.parameterLabel_3 = QtWidgets.QLabel(self)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.parameterLabel_3.setFont(font)
        self.parameterLabel_3.setObjectName("parameterLabel_3")
        self.verticalLayout.addWidget(self.parameterLabel_3)
        self.parameterLabel_4 = QtWidgets.QLabel(self)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.parameterLabel_4.setFont(font)
        self.parameterLabel_4.setObjectName("parameterLabel_4")
        self.verticalLayout.addWidget(self.parameterLabel_4)
        self.parameterLabel_5 = QtWidgets.QLabel(self)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.parameterLabel_5.setFont(font)
        self.parameterLabel_5.setObjectName("parameterLabel_5")
        self.verticalLayout.addWidget(self.parameterLabel_5)
        self.parameterLabel_6 = QtWidgets.QLabel(self)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.parameterLabel_6.setFont(font)
        self.parameterLabel_6.setObjectName("parameterLabel_6")
        self.verticalLayout.addWidget(self.parameterLabel_6)
        self.parameterLabel_7 = QtWidgets.QLabel(self)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.parameterLabel_7.setFont(font)
        self.parameterLabel_7.setObjectName("parameterLabel_7")
        self.verticalLayout.addWidget(self.parameterLabel_7)
        self.horizontalLayout.addLayout(self.verticalLayout)
        self.verticalLayout_2 = QtWidgets.QVBoxLayout()
        self.verticalLayout_2.setObjectName("verticalLayout_2")
        self.parameterText_1 = QtWidgets.QLineEdit(self)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.parameterText_1.sizePolicy().hasHeightForWidth())
        self.parameterText_1.setSizePolicy(sizePolicy)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.parameterText_1.setFont(font)
        self.parameterText_1.setObjectName("parameterText_1")
        self.verticalLayout_2.addWidget(self.parameterText_1)
        self.parameterText_2 = QtWidgets.QLineEdit(self)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.parameterText_2.sizePolicy().hasHeightForWidth())
        self.parameterText_2.setSizePolicy(sizePolicy)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.parameterText_2.setFont(font)
        self.parameterText_2.setObjectName("parameterText_2")
        self.verticalLayout_2.addWidget(self.parameterText_2)
        self.parameterText_3 = QtWidgets.QLineEdit(self)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.parameterText_3.sizePolicy().hasHeightForWidth())
        self.parameterText_3.setSizePolicy(sizePolicy)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.parameterText_3.setFont(font)
        self.parameterText_3.setObjectName("parameterText_3")
        self.verticalLayout_2.addWidget(self.parameterText_3)
        self.parameterText_4 = QtWidgets.QLineEdit(self)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.parameterText_4.sizePolicy().hasHeightForWidth())
        self.parameterText_4.setSizePolicy(sizePolicy)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.parameterText_4.setFont(font)
        self.parameterText_4.setObjectName("parameterText_4")
        self.verticalLayout_2.addWidget(self.parameterText_4)
        self.parameterText_5 = QtWidgets.QLineEdit(self)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.parameterText_5.sizePolicy().hasHeightForWidth())
        self.parameterText_5.setSizePolicy(sizePolicy)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.parameterText_5.setFont(font)
        self.parameterText_5.setObjectName("parameterText_5")
        self.verticalLayout_2.addWidget(self.parameterText_5)
        self.parameterText_6 = QtWidgets.QLineEdit(self)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.parameterText_6.sizePolicy().hasHeightForWidth())
        self.parameterText_6.setSizePolicy(sizePolicy)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.parameterText_6.setFont(font)
        self.parameterText_6.setObjectName("parameterText_6")
        self.verticalLayout_2.addWidget(self.parameterText_6)
        self.parameterText_7 = QtWidgets.QLineEdit(self)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.parameterText_7.sizePolicy().hasHeightForWidth())
        self.parameterText_7.setSizePolicy(sizePolicy)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.parameterText_7.setFont(font)
        self.parameterText_7.setObjectName("parameterText_7")
        self.verticalLayout_2.addWidget(self.parameterText_7)
        self.horizontalLayout.addLayout(self.verticalLayout_2)
        self.verticalLayout_3.addLayout(self.horizontalLayout)
        self.horizontalLayout_2 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")
        spacerItem = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout_2.addItem(spacerItem)
        self.saveBtn = QtWidgets.QPushButton(self)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.saveBtn.setFont(font)
        self.saveBtn.setObjectName("saveBtn")
        self.horizontalLayout_2.addWidget(self.saveBtn)
        spacerItem1 = QtWidgets.QSpacerItem(40, 20, QtWidgets.QSizePolicy.Expanding, QtWidgets.QSizePolicy.Minimum)
        self.horizontalLayout_2.addItem(spacerItem1)
        self.verticalLayout_3.addLayout(self.horizontalLayout_2)

        self.retranslateUi()
        QtCore.QMetaObject.connectSlotsByName(self)
        self.update_parameters(index_type,index_template)
        self.saveBtn.clicked.connect(self.save_parameters)
        self.textBoxVisible={}
        self.setFixedSize(self.sizeHint())        
    
    def save_parameters(self):
        '''
        Save Section Parameters for further use
        '''
        for child in self.findChildren(QtWidgets.QLineEdit):
            if(child.isVisible()):
                if(child.text()==''):
                    self.textBoxVisible={}
                    self.close()
                    return
                self.textBoxVisible[child.objectName()]=child.text()
        self.close()
    
    def update_parameters(self,index_type,index_template):
        '''
        Method for Updation of field in Section Parameters Dialog
        '''
        if(index_type==1):
            self.parameterLabel_2.hide()
            self.parameterText_2.hide()
            self.parameterLabel_4.hide()
            self.parameterText_4.hide()
            self.parameterLabel_5.hide()
            self.parameterText_5.hide()
            self.parameterLabel_1.setText('I-Section Type:')
            self.parameterLabel_3.setText('Spacing between the Columns(s):')
            self.parameterLabel_6.setText('Cover Plate Length(l):')
            self.parameterLabel_7.setText('Cover Plate Thickness(t):')
        elif(index_type==2):
            self.parameterLabel_2.hide()
            self.parameterText_2.hide()
            self.parameterLabel_4.hide()
            self.parameterText_4.hide()
            self.parameterLabel_5.hide()
            self.parameterText_5.hide()
            self.parameterLabel_6.setText('Cover Plate Length(l):')
            self.parameterLabel_7.setText('Cover Plate Thickness(t):')
            if(index_template==1):
                self.parameterLabel_1.setText('Channel Section Type:')
                self.parameterLabel_3.setText('Spacing between two Channels(s):')
            elif(index_template==2):
                self.parameterLabel_1.setText('Angle Section Type:')
                self.parameterLabel_3.setText('Spacing between two Angles(s):')
        elif(index_type==3):
            self.parameterLabel_2.hide()
            self.parameterText_2.hide()
            self.parameterLabel_5.hide()
            self.parameterText_5.hide()
            self.parameterLabel_1.setText('Angle Section Type:')
            if(index_template==1):
                self.parameterLabel_3.setText('Spacing Horizontal(s):')
                self.parameterLabel_4.setText('Spacing Vertical(s*):')
                self.parameterLabel_6.setText('Gusset Plate Length(l):')
                self.parameterLabel_7.setText('Gusset Plate Thickness(t):') 
            elif(index_template==2):
                self.parameterLabel_4.hide()
                self.parameterText_4.hide()
                self.parameterLabel_3.setText('Spacing Horizontal(s):')
                self.parameterLabel_6.setText('Gusset Plate Length(l):')
                self.parameterLabel_7.setText('Gusset Plate Thickness(t):')
            elif(index_template==3):
                self.parameterLabel_4.hide()
                self.parameterText_4.hide()
                self.parameterLabel_3.setText('Spacing between the Angle Section(s):')
                self.parameterLabel_6.setText('Gusset Plate Length(l):')
                self.parameterLabel_7.setText('Gusset Plate Thickness(t):')
            elif(index_template==4):
                self.parameterLabel_4.hide()
                self.parameterText_4.hide()
                self.parameterLabel_3.setText('Spacing between the Angles(s):')
                self.parameterLabel_6.setText('Gusset Plate Length(l):')
                self.parameterLabel_7.setText('Gusset Plate Thickness(t):')
            elif(index_template==5):
                self.parameterLabel_3.setText('Spacing between Sections_Horizontal(s):')
                self.parameterLabel_4.setText('Spacing between Sections_Vertical(s*):')
                self.parameterLabel_6.setText('Plate Length(l):')
                self.parameterLabel_7.setText('Plate Thickness(t):') 
        elif(index_type==4):
            self.parameterLabel_2.hide()
            self.parameterText_2.hide()
            if(index_template==1):
                self.parameterLabel_4.hide()
                self.parameterText_4.hide()
                self.parameterLabel_5.hide()
                self.parameterText_5.hide()
                self.parameterLabel_7.hide()
                self.parameterText_7.hide()
                self.parameterLabel_1.setText('I-Section Type:')
                self.parameterLabel_3.setText('Spacing between Lip and Web(s):')
                self.parameterLabel_6.setText('Length of Lips(l):')
            elif(index_template==2):
                self.parameterLabel_4.hide()
                self.parameterText_4.hide()
                self.parameterLabel_1.setText('I-Section Type:')
                self.parameterLabel_3.setText('Spacing between the two Sections(s):')
                self.parameterLabel_5.setText('I-Sections Connection Angle(𝛼):')
                self.parameterLabel_6.setText('Plate Length(l):')
                self.parameterLabel_7.setText('Cover Plate Thickness(t):') 
            elif(index_template==3):
                self.parameterLabel_6.hide()
                self.parameterText_6.hide()
                self.parameterLabel_7.hide()
                self.parameterText_7.hide()
                self.parameterLabel_1.setText('SHR/RHS Tubes Type:')
                self.parameterLabel_3.setText('Spacing between the Tubes_Horizontal(s):')
                self.parameterLabel_4.setText('Spacing between the Tubes_Vertical(s*):')
                self.parameterLabel_5.setText('Selecting the Proper Tube:')
        elif(index_type==5):
            self.parameterLabel_4.hide()
            self.parameterText_4.hide()
            self.parameterLabel_5.hide()
            self.parameterText_5.hide()
            self.parameterLabel_6.hide()
            self.parameterText_6.hide()
            self.parameterLabel_7.hide()
            self.parameterText_7.hide()
            self.parameterLabel_1.setText('I-Section Type:')
            self.parameterLabel_2.setText('Channel Section Type:')
            self.parameterLabel_3.setText('Spacing between Channel and I-Section:')

    def retranslateUi(self):
        _translate = QtCore.QCoreApplication.translate
        self.setWindowTitle(_translate("Dialog", "Section Parameters"))
        self.parameterLabel_1.setText(_translate("Dialog", "I-Section Type:"))
        self.parameterLabel_2.setText(_translate("Dialog", "Channel Type:"))
        self.parameterLabel_3.setText(_translate("Dialog", "Spacing (s):"))
        self.parameterLabel_4.setText(_translate("Dialog", "Spacing (s*):"))
        self.parameterLabel_5.setText(_translate("Dialog", "Alpha (𝛼):"))
        self.parameterLabel_6.setText(_translate("Dialog", "Length (l):"))
        self.parameterLabel_7.setText(_translate("Dialog", "Thickness (t):"))
        self.saveBtn.setText(_translate("Dialog", "Save"))
