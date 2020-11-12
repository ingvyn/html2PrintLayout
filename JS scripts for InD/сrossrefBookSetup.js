try {
  app.doScript(
    Main,
    undefined,
    undefined,
    UndoModes.ENTIRE_SCRIPT,
    'Run Script'
  );
} catch (e) {
  alert(e.message);
}

function Main() {
  var handleBook = app.activeBook;
  handleBook.updateAllNumbers();
  var actionByChapter = {
    'Глава 1: раздел Прук': {
      handleWithIndexDoc: false,
      chapterDocName: 'Glava_1_4.indd',
      xPathExpr:
        'descendant::Puk_Preparat/descendant::crossRef[@href] | descendant::PUK_DVName/descendant::crossRef[@href]',
    },
    'Глава 1: раздел Описания': {
      handleWithIndexDoc: false,
      chapterDocName: 'Glava_1_5.indd',
      xPathExpr:
        'descendant::OPIS_DV/descendant::crossRef[@href] | descendant::Opis_Synonym_ZAK/descendant::crossRef[@href]',
    },
    'Глава 1: раздел Идентификатора': {
      handleWithIndexDoc: true,
      indexDocName: 'Glava_1_7.indd',
      chapterDocName: 'Identifikator.indd',
      xPathExpr: 'descendant::crossRef[@href]',
    },
    'Глава 2: Фарм. указатель': {
      handleWithIndexDoc: true,
      indexDocName: 'Glava_2_1.indd',
      chapterDocName: 'Glava_2_2.indd',
      xPathExpr:
        'descendant::UkFG_TName/descendant::crossRef[@href] | descendant::UkFG_DV/descendant::crossRef[@href]',
    },
    'Глава 3: Мкб указатель': {
      handleWithIndexDoc: true,
      indexDocName: 'Glava_3_1.indd',
      chapterDocName: 'Glava_3_2.indd',
      xPathExpr:
        'descendant::UkMKB_TName/descendant::crossRef[@href] | descendant::UkMKB_DV/descendant::crossRef[@href]',
    },
    'Глава 4: АТХ указатель': {
      handleWithIndexDoc: false,
      chapterDocName: 'Glava_4.indd',
      xPathExpr: 'descendant::UkATC_TName/descendant::crossRef[@href]',
    },
    'Глава 5: Указатель производителей': {
      handleWithIndexDoc: true,
      indexDocName: 'Glava_5_1.indd',
      chapterDocName: 'Glava_5_2.indd',
      xPathExpr:
        'descendant::UKPR_PREP/descendant::crossRef[@href] | descendant::TN_FP/descendant::crossRef[@href] | descendant::DV_FP/descendant::crossRef[@href]',
    },
  };
  var currentDoc;
  var descriptionsDocName = 'Glava_1_5.indd';
  var listAction = [
    'Глава 1: раздел Прук',
    'Глава 1: раздел Описания',
    'Глава 1: раздел Идентификатора',
    'Глава 2: Фарм. указатель',
    'Глава 3: Мкб указатель',
    'Глава 4: АТХ указатель',
    'Глава 5: Указатель производителей',
  ];
  descriptionDoc = openChapter(handleBook, descriptionsDocName);
  var storeDrugDescriptionDestinationNames = allDestinationNamesForDocument(
    descriptionDoc
  ); //массив привязок главы описаний понадобится для простановки перекр. ссылок по всем главам

  var hlights = highlight_list(listAction);

  for (var vol = 0; vol < listAction.length; vol++) {
    hlights.children[1].selection = vol;
    hlights.show();
    currentDoc = openChapter(
      handleBook,
      actionByChapter[listAction[vol]].chapterDocName
    );
    if (actionByChapter[listAction[vol]].handleWithIndexDoc) {
      // если в разделе необходимо проставить номера страниц в указателе раздела
      indexDoc = openChapter(
        handleBook,
        actionByChapter[listAction[vol]].indexDocName
      );
      var storeCurrentDocDestinationNames = allDestinationNamesForDocument(
        currentDoc
      ); // формируется массив привязок основной главы текущего раздела
      setSourcesForDocument(
        indexDoc,
        currentDoc,
        storeCurrentDocDestinationNames,
        'descendant::crossRef[@href]'
      ); // проставляются номера страниц в указателе раздела (indexDoc)
      indexDoc.close(SaveOptions.YES);
    }
    setSourcesForDocument(
      currentDoc,
      descriptionDoc,
      storeDrugDescriptionDestinationNames,
      actionByChapter[listAction[vol]].xPathExpr
    );

    if (currentDoc !== descriptionDoc) {
      currentDoc.close(SaveOptions.YES);
    }
  }
  descriptionDoc.close(SaveOptions.YES);
  hlights.close();

  function openChapter(book, docName) {
    var chapterDocFile;
    var isChapterinBook = book.bookContents.itemByName(docName).status;
    if (isChapterinBook == BookContentStatus.MISSING_DOCUMENT) {
      throw new Error('В книге отсутствует раздел' + docName);
    }
    if (isChapterinBook !== BookContentStatus.DOCUMENT_IS_OPEN) {
      chapterDocFile = book.bookContents.itemByName(docName).fullName;
      return app.open(chapterDocFile, false);
    } else {
      return app.documents.itemByName(docName);
    }
  }
}

function highlight_list(array) {
  var w = new Window('palette', undefined, undefined, { borderless: true });
  w.margins = [5, 5, 5, 5];
  w.add('statictext', undefined, 'Простановка перекрестных ссылок идет в:');
  w.add('listbox', undefined, array);
  return w;
}

// универсальные функции , устанавливащие привязки в документе
function allDestinationNamesForDocument(doc) {
  //формирование объекта с ключами из имен объектов привязки документа
  var key;
  var storeDestinationNames = {};
  if (doc.hyperlinkTextDestinations.length === 0) {
    //массив текстовых привязок документа
    setDestinationForDocument(doc); // если в документе нет текстовых привязок, управление забирает функция, проставляющая их
  }
  for (var i = 0; i < doc.hyperlinkTextDestinations.length; i++) {
    // производится наполнение объекта с ключами, взятыми из имен элементов массива текстовых привязок
    key = doc.hyperlinkTextDestinations[i].name; //для последующего быстрого поиска по именам ключей. доступ к имена ключей осуществляется быстрее, чем перебор массива.
    storeDestinationNames[key] = i;
  }
  return storeDestinationNames;
}

function setDestinationForDocument(doc) {
  // поиск всех xml-элементов anchorCR c атрибутом name. Текст из родителей этих элементов заносится в массив тестовых привязок этого активного документа
  var xmlRoot = doc.xmlElements[0];
  var xmlAnchorRefArr = xmlRoot.evaluateXPathExpression(
    'descendant::anchorCR[@name]'
  );
  var mySetDest = doc.hyperlinkTextDestinations;
  var currentName;
  var currentDest;
  for (var i = 0; i < xmlAnchorRefArr.length; i++) {
    //перебираем все узлы, имеющие элементы anchorCR
    currentName = xmlAnchorRefArr[i].xmlAttributes[0].value; //берется значение единственного атрибута name
    workXmlElement = xmlAnchorRefArr[i].parent; //переходим к родителю элемента
    try {
      currentDest = mySetDest.add(workXmlElement.texts[0]); //текст элемента добавляется в массив-свойство активного документа, состоящий из текстов-привязок
      currentDest.name = currentName; //свойству-имени текста привязки  присваивается присваивается уникальное имя, в данном случае значение атрибутата name элемента anchorCR
    } catch (e) {
      continue;
    }
  }
}
// универсальная функция , устанавливащия ссылкии в документе
function setSourcesForDocument(
  srcDoc,
  dstDoc,
  objectForDestinationSearch,
  xpathExpression
) {
  var currentDest;
  var currentSource;
  var targetHref;
  var textWhereToInsert;
  var xRefForm = srcDoc.crossReferenceFormats.item('Page Number'); //определяется формат перекрестной ссылки. В самом документе необходимо проверить формат, чтобы он состоял только из <page>
  var xmlRoot = srcDoc.xmlElements[0];
  var xmlCrossRefArr = xmlRoot.evaluateXPathExpression(xpathExpression);
  for (i = 0; i < xmlCrossRefArr.length; i++) {
    targetHref = xmlCrossRefArr[i].xmlAttributes[0].value; //определяется значение единственного атрибута (href)
    if (
      targetHref !== 'undefined' &&
      targetHref in objectForDestinationSearch
    ) {
      currentDest =
        dstDoc.hyperlinkTextDestinations[
          objectForDestinationSearch[targetHref]
        ]; //ссылка находит объект текстовой привязки по значению объекта objectForDestinationSearch с найденным ключом
      textWhereToInsert = xmlCrossRefArr[i].texts[0]; //предполагается, что содержимое элемента состоит из пустого наполнителя 0000
      currentSource = srcDoc.crossReferenceSources.add(
        textWhereToInsert,
        xRefForm
      ); //вместо наполнителя добавляется перекрестная ссылка
      srcDoc.hyperlinks.add(currentSource, currentDest); //в массив, связывающий ссылки и тексты привязки, добавляется элемент
    }
  }
}
