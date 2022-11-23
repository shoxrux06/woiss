import 'package:flutter/material.dart';
import 'package:furniture_app/providers/invoice_provider.dart';
import 'package:furniture_app/utils/app_constants.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/auth_controller.dart';
import '../../data/model/agent.dart';
import 'package:get/get.dart';

import '../../data/model/user.dart';
import '../../providers/cart_provider.dart';
import '../../utils/cache_manager.dart';
import '../../utils/color_resources.dart';
import '../account/account_screen.dart';
import 'login_screen.dart';

class ChangeAccountScreen extends StatefulWidget {
  const ChangeAccountScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChangeAccountScreen> createState() => _ChangeAccountScreenState();
}

class _ChangeAccountScreenState extends State<ChangeAccountScreen> {
  List<AgentModel> agentList = [];

  bool isEqual = false;

  getData() async {
    final controller = Get.find<AuthController>();
    final data = await controller.getBranchAgentList();
    if (data != null) {
      agentList = List<AgentModel>.from(data.map((item) => AgentModel.fromJson(item)));
    } else {
      agentList = [];
    }
  }

  String? userName;

  getSelectedUserIndex() async {
    final cacheManager = CacheManager();
    setState((){});
    userName = await cacheManager.getUserName() ?? '';
    print('userName*********$userName**********');
  }

  @override
  void initState() {
    super.initState();
    getData();
    getSelectedUserIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<AuthController>(
      builder: (controller) {
        return agentList.isEmpty? Container(
          color: ColorsResources.PRIMARY_BACKROUND_COLOR,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ):
        Container(
            color: ColorsResources.PRIMARY_BACKROUND_COLOR,
            child: Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: agentList.length,
                    itemBuilder: (context, index) {
                      print('|||||$index|||||');
                      return Container(
                        child: InkWell(
                          onTap: () async {
                            print('*****$index******');
                            final cacheManager = CacheManager();
                            setState(() {});

                            await cacheManager.saveUserId(agentList[index].id);
                            int userId = await cacheManager.getUserId() ?? 0;

                            await context.read<InvoiceProvider>().getCommercials(userId);
                            await context.read<InvoiceProvider>().getContracts(userId);
                            await cacheManager.saveUserName(agentList[index].username);

                            print('userId>>$userId');

                            context.read<InvoiceProvider>().setCommercialEditOrNot(false);
                            context.read<CartProvider>().updateProductCounter();
                            context.read<CartProvider>().clearTotalPrice();
                            context.read<CartProvider>().clearCart();
                            Navigator.of(context).pop();
                          },

                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorsResources.PRIMARY_COLOR
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${agentList[index].username.substring(0, 1).toUpperCase()}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 24,
                                      ),
                                      Text(agentList[index].username, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                                      Spacer(),
                                      userName == agentList[index].username?Icon(Icons.check, color: Colors.white,): Container()
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: ColorsResources.PRIMARY_COLOR,
                                  height:1,
                                )
                              ],
                            ),
                          ),

                        ),
                      );
                    }),
              ],
            )
        );
      },
    )
    );
  }
}
