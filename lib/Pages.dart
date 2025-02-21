import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Page1Screen extends StatefulWidget {
  const Page1Screen({super.key});

  @override
  Page1ScreenState createState() => Page1ScreenState();
}

class Page1ScreenState extends State<Page1Screen> {
  List<String> _containerTitles = [
    'Бюджетирование',
    'Сбережения',
    'Инвестиции',
  ];

  List<Color> _containerColors = [
    Colors.blue,
    Colors.orange,
    Colors.green,
  ];

  List<String> _containerTexts = [
    '''Бюджет — это основа финансового планирования, которая помогает эффективно управлять деньгами, избегать долгов и откладывать на будущее. Составление бюджета включает три ключевых компонента: доходы, расходы и сбережения. Методика 50/30/20 является одной из популярных стратегий, рекомендуя распределять доходы следующим образом:
	•	50% на основные потребности (жилье, еда, счета),
	•	30% на желания (развлечения, покупки),
	•	20% на сбережения и долгосрочные цели (накопления, инвестиции).''',
    '''Создание финансовой подушки — важный элемент защиты от непредвиденных обстоятельств. Считается, что на случай потери дохода рекомендуется иметь сбережения, покрывающие расходы за 3–6 месяцев. Лучшие инструменты для накопления включают:
    • накопительные счета с высоким процентным ставками,
    • депозитные счета,
    • краткосрочные облигации.''',
    'Инвестиции — это способ увеличить свои сбережения в долгосрочной перспективе. Важно понимать, что инвестиции несут определенные риски, поэтому рекомендуется разделять вложения по разным активам, чтобы минимизировать риски.',
  ];

  List<String> _bottomContainerTitles = [
    'Кредиты и займы',
    'Управление долгами',
  ];

  List<String> _bottomContainerTexts = [
    '''Как правильно использовать кредитные карты
Кредитные карты могут быть полезны, если использовать их грамотно:
	•	Кэшбэк и бонусные программы могут помочь экономить на покупках.
	•	Своевременные выплаты — важный аспект. Если задолженность по карте выплачивается вовремя, можно избежать высоких процентов и сохранить кредитный рейтинг.
Ипотека и автокредиты
При планировании крупных покупок, таких как жилье или автомобиль, важно правильно оценить свои финансовые возможности. Необходимо учитывать процентные ставки и срок выплат. Всегда важно проверять условия досрочного погашения, чтобы не попасть на штрафы.''',
    '''Избегание долговых ловушек
Потребительские кредиты и микрозаймы часто имеют высокие проценты, поэтому стоит избегать долговых обязательств с неподъемными условиями. Используйте только проверенные банки и кредитные организации с прозрачными условиями.
Консолидация долгов
Для тех, кто имеет несколько долгов, существует опция их объединения в один кредит с более низкой процентной ставкой. Это поможет упорядочить выплаты и сэкономить на процентах.''',
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize:
          Size(375, 812), // Установите размеры дизайна, которые вы используете
      minTextAdapt: true,
    );

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/fingram.png',
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(74),
            left: ScreenUtil().setWidth(10),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.transparent,
              iconSize: ScreenUtil().setWidth(30),
            ),
          ),
          Column(
            children: [
              SizedBox(height: ScreenUtil().setHeight(100)),
              Expanded(
                child: DraggableScrollableSheet(
                  expand: true,
                  initialChildSize: 1.0,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return ListView(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                      children: [
                        ...List.generate(_containerTitles.length, (index) {
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(8)),
                            ),
                            margin: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(8)),
                            child: ExpansionTile(
                              title: Text(
                                _containerTitles[index],
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(16),
                                  color: _containerColors[index],
                                ),
                              ),
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.all(ScreenUtil().setWidth(16)),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: ScreenUtil().setWidth(4),
                                          color: _containerColors[index],
                                          margin: EdgeInsets.only(
                                              right: ScreenUtil().setWidth(8)),
                                        ),
                                        Expanded(
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: index == 1
                                                      ? 'Создание финансовой подушки '
                                                      : _containerTexts[index]
                                                              .split(' ')
                                                              .first +
                                                          ' ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: index == 1
                                                      ? _containerTexts[index]
                                                          .replaceFirst(
                                                              'Создание финансовой подушки ',
                                                              '')
                                                      : _containerTexts[index]
                                                          .split(' ')
                                                          .skip(1)
                                                          .join(' '),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        ...List.generate(_bottomContainerTitles.length,
                            (index) {
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(8)),
                            ),
                            margin: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(8)),
                            child: ExpansionTile(
                              title: Text(
                                _bottomContainerTitles[index],
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(14),
                                  color: Colors.black,
                                ),
                              ),
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.all(ScreenUtil().setWidth(16)),
                                  child: Text(
                                    _bottomContainerTexts[index],
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(14),
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Page2Screen extends StatelessWidget {
  const Page2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize:
          Size(375, 812), // Установите размеры дизайна, которые вы используете
      minTextAdapt: true,
    );

    List<String> _containerTitles = [
      'Права потребителя при покупке товара',
      'Защита от недобросовестных продавцов',
      'Условия рассрочки и кредитования',
    ];

    List<Color> _containerColors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
    ];

    List<String> _containerTexts = [
      '''

По законодательству, покупатель имеет право на возврат товара в течение 14 дней с момента покупки, если товар не подошел по форме, цвету или размеру. Исключения составляют только некоторые категории, такие как парфюмерия и лекарства.
Гарантии и сервисное обслуживание
Гарантия — это обязательство продавца или производителя безвозмездно устранить недостатки товара. Стандартный гарантийный срок — 1 год. Важно сохранять чеки и гарантийные талоны для подтверждения своих прав.
Права при покупке онлайн
При дистанционной покупке товаров (например, в интернет-магазинах) потребитель также имеет право на возврат товара в течение 7 дней с момента получения. Важно ознакомиться с условиями возврата, которые предлагает интернет-магазин.''',
      '''

Покупатели могут столкнуться с мошенничеством при заказе товаров через интернет. Всегда стоит проверять информацию о продавце, читать отзывы, пользоваться защищенными методами оплаты (например, банковские карты с защитой покупателя). При возникновении споров покупатель имеет право обратиться в Роспотребнадзор или суд.
Куда обращаться при нарушении прав
	•	Роспотребнадзор — государственный орган, который защищает права потребителей.
	•	Общественные организации — они могут помочь с юридическими консультациями и представлением интересов потребителя.''',
      '''

При покупке в рассрочку нужно внимательно читать договор и обращать внимание на следующие моменты:
	•	Процентная ставка (некоторые рассрочки могут содержать скрытые проценты),
	•	Условия досрочного погашения,
	•	Дополнительные комиссии''',
    ];

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/zashita.png',
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(74),
            left: ScreenUtil().setWidth(10),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.transparent,
              iconSize: ScreenUtil().setWidth(30),
            ),
          ),
          Column(
            children: [
              SizedBox(height: ScreenUtil().setHeight(100)),
              Expanded(
                child: DraggableScrollableSheet(
                  expand: true,
                  initialChildSize: 1.0,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return ListView(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                      children: List.generate(_containerTitles.length, (index) {
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().setWidth(8)),
                          ),
                          margin: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(8)),
                          child: ExpansionTile(
                            title: Text(
                              _containerTitles[index],
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(16),
                                color: _containerColors[index],
                              ),
                            ),
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setWidth(16)),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: ScreenUtil().setWidth(4),
                                        color: _containerColors[index],
                                        margin: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(8)),
                                      ),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              if (index == 0) ...[
                                                TextSpan(
                                                  text: 'Право на возврат ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: _containerTexts[index]
                                                      .replaceFirst(
                                                          'Право на возврат ',
                                                          ''),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                  ),
                                                ),
                                              ] else if (index == 1) ...[
                                                TextSpan(
                                                  text:
                                                      'Как бороться с мошенничеством ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: _containerTexts[index]
                                                      .replaceFirst(
                                                          'Как бороться с мошенничеством ',
                                                          ''),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                  ),
                                                ),
                                              ] else if (index == 2) ...[
                                                TextSpan(
                                                  text:
                                                      'Особенности покупки в рассрочку ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: _containerTexts[index]
                                                      .replaceFirst(
                                                          'Особенности покупки в рассрочку ',
                                                          ''),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                  ),
                                                ),
                                              ] else ...[
                                                TextSpan(
                                                  text: _containerTexts[index]
                                                          .split(' ')
                                                          .first +
                                                      ' ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: _containerTexts[index]
                                                      .split(' ')
                                                      .skip(1)
                                                      .join(' '),
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize:
                                                        ScreenUtil().setSp(14),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Page3Screen extends StatelessWidget {
  const Page3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(375, 812),
      minTextAdapt: true,
    );

    String _containerTitle =
        'Использование “InvoSnap” для финансового планирования';
    Color _containerColor = Colors.purple;
    String _containerText =
        '''Система категорий чеков в приложении поможет лучше отслеживать, на что уходят деньги, что особенно полезно для тех, кто хочет управлять своими расходами. Пользователь может анализировать данные, создавая месячные или квартальные отчеты.''';

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/sovet.png',
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(74),
            left: ScreenUtil().setWidth(10),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.transparent,
              iconSize: ScreenUtil().setWidth(30),
            ),
          ),
          Column(
            children: [
              SizedBox(height: ScreenUtil().setHeight(100)),
              Expanded(
                child: DraggableScrollableSheet(
                  expand: true,
                  initialChildSize: 1.0,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return ListView(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                      children: [
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().setWidth(8)),
                          ),
                          margin: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(8)),
                          child: ExpansionTile(
                            title: Text(
                              _containerTitle,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(16),
                                color: _containerColor,
                              ),
                            ),
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setWidth(16)),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: ScreenUtil().setWidth(4),
                                        color: _containerColor,
                                        margin: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(8)),
                                      ),
                                      Expanded(
                                        child: Text(
                                          _containerText,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: ScreenUtil().setSp(14),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Page4Screen extends StatelessWidget {
  const Page4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(375, 812),
      minTextAdapt: true,
    );

    List<String> _containerTitles = [
      'Как правильно хранить финансовые данные',
      'Как избежать мошенничества',
    ];

    List<Color> _containerColors = [
      Colors.blue,
      Colors.green,
    ];

    List<String> _containerTexts = [
      '''•	Используйте надежные пароли и регулярно их обновляйте.
•	Включите двухфакторную аутентификацию.
•	Избегайте использования общественных сетей Wi-Fi для доступа к своим финансовым данным.''',
      '''Избегайте фишинговых писем и подозрительных сайтов, не передавайте данные своей карты третьим лицам и никогда не вводите их на небезопасных ресурсах''',
    ];

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/zashitadannih.png',
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: ScreenUtil().setHeight(74),
            left: ScreenUtil().setWidth(10),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.transparent,
              iconSize: ScreenUtil().setWidth(30),
            ),
          ),
          Column(
            children: [
              SizedBox(height: ScreenUtil().setHeight(100)),
              Expanded(
                child: DraggableScrollableSheet(
                  expand: true,
                  initialChildSize: 1.0,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return ListView(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                      children: List.generate(_containerTitles.length, (index) {
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(ScreenUtil().setWidth(8)),
                          ),
                          margin: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(8)),
                          child: ExpansionTile(
                            title: Text(
                              _containerTitles[index],
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(16),
                                color: _containerColors[index],
                              ),
                            ),
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil().setWidth(16)),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: ScreenUtil().setWidth(4),
                                        color: _containerColors[index],
                                        margin: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(8)),
                                      ),
                                      Expanded(
                                        child: Text(
                                          _containerTexts[index],
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: ScreenUtil().setSp(14),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
