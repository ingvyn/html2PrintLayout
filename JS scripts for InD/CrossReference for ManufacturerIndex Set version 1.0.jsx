//DESCRIPTION:
//Скрипт осуществляет простановку перекрестных ссылок для главы "Указатель производителей и их представителей в России" в разделах 5.1-5.2 при условии, что в InDesign открыты файлы Glava_5_1.indd (разделы 5.1) и Glava_5_2.indd (раздел 5.2), а также файл главы описаний Glava_1_5.indd. Ссылки проставляются при условии, что xml-элементы, связанные с макетом, которые должны стать sources перекрестных ссылок, содержат дочерние элементы anchorCR, а xml-элементы, соотв. элементам макета, которые должны быть якорями перекрестных сслыок, соедржат дочерние элементы crossRef.
// CrossReference for ManufacturerIndex Set  version 1.0.jsx
//
// Modified 2019-04-03
// Igor Nikitin, Rls
//
//

//Main();
// If you want the script to be un-doable, comment out the line above, and remove the comment from the line below
app.doScript(Main, undefined, undefined, UndoModes.ENTIRE_SCRIPT, 'Run Script');

function Main() {
  // установка переменной-ссылки на документ, содержащий раздел "Описания л.с. ..." из главы описаний
  var doc0 = app.documents.itemByName('Glava_1_5.indd');
  // установка переменной-ссылки на документ-введение, предваряющий "Нозологический указатель" и содержащий основные разделы МКБ-10 и алфавитный перечень
  var doc1 = app.documents.itemByName('Glava_5_1.indd');
  //установка переменной-ссылки на документ, содержащий раздел "Указатель л.с. по МКБ-10" из главы "Нозологический указатель"
  var doc2 = app.documents.itemByName('Glava_5_2.indd');

  try {
    if (!(doc0.name && doc1.name && doc2.name)) {
      throw new ReferenceError('Ошибка чтения данных');
    }
  } catch (e) {
    if (e.name == 'ReferenceError') {
      alert(
        'Для работы скрипта необходимо открыть документы Glava_1_5.indd, Glava_5_1.indd, Glava_5_2.indd. Откройте все три документа и запустите скрипт снова'
      );
      return;
    } else {
      throw e;
    }
  }
  //объявление объекта с ключами, взятыми из имен элементов массива текстовых привязок документа doc0, для осуществления быстрого поиска по именам
  var storeDrugDescriptionDestinationNames = allDestinationNamesForDocument(
    doc0
  );
  //объявление объекта с ключами, взятыми из имен элементов массива текстовых привязок документа doc2,  для осуществления быстрого поиска по именам
  var storeManufacturerIndexDestinationNames = allDestinationNamesForDocument(
    doc2
  );
  //установка номеров страниц перекрестных ссылок в "Алфавитном перечне предприятий и фирм - участников РЛС" (стиль абзацев и соотв. xml-элементов FIRM_CUST_FC, FIRM_CUST)
  setSourcesForDocument(
    doc1,
    doc2,
    storeManufacturerIndexDestinationNames,
    'descendant::FIRM_CUST_FC/descendant::crossRef[@href] | descendant::FIRM_CUST/descendant::crossRef[@href]'
  );

  //установка номеров страниц перекрестных ссылок в "Производители л.с. и их представители с перечнем выпускаемой продукции" (стиль абзацев и соотв. xml-элементов UKPR_PREP); поиск якорей для этих ссылок проводится в файле раздела главы 1 "Описания л.с., БАДов, мед. изделий"
  setSourcesForDocument(
    doc2,
    doc0,
    storeDrugDescriptionDestinationNames,
    'descendant::UKPR_PREP/descendant::crossRef[@href]'
  );

  //установка номеров страниц перекрестных ссылок в "Производители л.с. и их представители с перечнем выпускаемой продукции" (стиль абзацев и соотв. xml-элементов TN_FP, DV_FP); поиск якорей для этих ссылок проводится в файле раздела главы 1 "Описания л.с., БАДов, мед. изделий"
  setSourcesForDocument(
    doc2,
    doc0,
    storeDrugDescriptionDestinationNames,
    'descendant::TN_FP/descendant::crossRef[@href] | descendant::DV_FP/descendant::crossRef[@href]'
  );

  return;

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
            }
        catch (e) {
            continue;
            }
    }
  }

  // функция проставляет ссылки с номерами страниц в документе srcDoc, используя в качестве аргументов ссылку на документ dstDoc с якорями (привязками destinations) для перекрестных ссылок, используя объект с именами текстовых привязок в dstDoc, XPath выражение для поиска элементов croosRef с наполнителями 0000, на место которых функция должна вставить номера страниц перекрестных ссылок
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
}
