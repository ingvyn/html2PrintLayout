//DESCRIPTION: Сохраняет каждую страничку - будущий "кирпич" как eps. Имя файла забираем из параграфа со стилем PageNum
// KirpichExport2Eps.jsx
//
// Modified 2019-01-25
// Igor Nikitin

//
// List of things required for the script to run

//Main();
// If you want the script to be un-doable, comment out the line above, and remove the comment from the line below
app.doScript(Main, undefined, undefined, UndoModes.ENTIRE_SCRIPT,"Run Script");

function Main() {
	// Check to see whether any InDesign documents are open.
	// If no documents are open, display an error message.
	if (app.documents.length > 0) {
		var myDoc = app.documents[0];
        var myAllPages = [];
        var myCPTFrame;
        var myCTParagraphs = [];
        var style2Find;
        var currEPSPath = myDoc.filePath.absoluteURI; // полный путь к открытому файлу InDesign
//        var currEPSPath = "C:/Users/иникитин/Documents/ENCIKLOP InDesign/TransformingHTML2_xml/Identifyer";
//		получаем массив страниц		
        myAllPages = myDoc.pages;
       for (var i=0; i<myAllPages.length; i++) {
           myEps2Export = null;
//			на каждой странице берем массив текстовых фреймов. В нашем случае нам с наибольшей вероятностью нужен первый текстовый фрейм		   
           myCPTFrame = myAllPages[i].textFrames[0];
// 			получаем массив параграфов		   
           myCTParagraphs = myCPTFrame.paragraphs;
           for (var parnum=0; parnum<myCTParagraphs.length; parnum++) {
//				присваиваем переменной имя каждого параграфа			   
               style2Find = myCTParagraphs[parnum].appliedParagraphStyle.name;
//				делаем проверку имени параграфа на соответствие нужному PageNum			   
               if (style2Find == "PageNum" || style2Find == "pagenum"){
                   var file_ofPageNum = [];
// 					считываем содержимое параграфа, очищая его от лишних знаков в конце строки (перевод строки и пр.)				   
                   file_ofPageNum = myCTParagraphs[parnum].contents.split(/\s/);
// 					создаем объект типа File по предварительно заданному пути + содержимое параграфа (набор цифр)	
//                    myCPTFrame.createOutlines;
                   myEps2Export = new File (currEPSPath + "/" + file_ofPageNum[0] + ".eps");
//                    alert(myDoc.filePath);
//                   alert(myCTParagraphs[parnum].contents); 
               }
                myCTParagraphs[parnum].select(SelectionOptions.replaceWith);
//                app.select(getTextRef(myCTParagraphs[parnum], 1), SelectionOptions.replaceWith);
                try {
                    app.selection[0].createOutlines(true); 
                } catch (e) {continue;}
                
           }
//		задаем настройки экспорта eps, указывая диапазон страниц для экспорта 
            if (myEps2Export != null) {
                app.epsExportPreferences.pageRange = String(i+1);
//	    выполняем экспорт документа с заданными настройками экспорта				   
                myDoc.exportFile (ExportFormat.EPS_TYPE, myEps2Export);
                };
        }

	}
	else {
		// No documents are open, so display an error message.

	}
}

/* function getTextRef(myPara, n) {
 var tf = myPara.parent.texts[0]; // text flow
 var s = myPara.index; // start
 var e = myPara.characters[-1].index; // end
 for (j = n-1; j > 0; j--) {
   try {
     myPara = myPara.insertionPoints[-1].paragraphs[0];
   } catch (e) { break }
   e = myPara.characters[-1].index; // updated end
 }
 return tf.characters.itemByRange(s, e).texts[0];
} */
