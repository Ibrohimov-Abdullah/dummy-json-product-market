import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:network_learning/models/all_products.dart';
import 'package:network_learning/models/user_model.dart';
import 'package:network_learning/services/network_service.dart';

import '../models/products_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  AllProductModel? allProductModel;
  List<Products> list = [];
  bool isLoading = false;
  TextEditingController controller = TextEditingController();

  Future<void> getAllProducts() async {
    isLoading = false;
    String? result = await NetworkService.getDate(
        api: NetworkService.apiGetAllProducts,
        param: NetworkService.paramEmpty());
    if (result != null) {
      allProductModel = allProductModelFromJson(result);
      list = allProductModel!.products!;
      isLoading = true;
      setState(() {});
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    getAllProducts();
    super.initState();
  }

  Future<void> updateProducts(Products product) async {
    String? result = await NetworkService.updateDate(
        api: NetworkService.apiGetAllProducts,
        param: NetworkService.paramEmpty(),
        date: product.toJson());
  }

  Future<void> searchProducts(String product) async {
    isLoading = false;
    list = [];
    setState(() {});
    int? parse = int.tryParse(product);
    String? result;
    if(parse != null){
      result = await NetworkService.getDate(
          api: NetworkService.apiSearchId,
          param: NetworkService.paramEmpty());

      if (result != null) {
        allProductModel = allProductModelFromJson(result);
        list = allProductModel!.products!;
        isLoading = true;
        setState(() {});
      } else {
        isLoading = false;
        setState(() {});
      }
    }else{
      result = await NetworkService.getDate(
          api: NetworkService.apiSearchProduct,
          param: NetworkService.paramSearchProducts(product));

      if (result != null) {
        allProductModel = allProductModelFromJson(result);
        list = allProductModel!.products!;
        isLoading = true;
        setState(() {});
      } else {
        isLoading = false;
        setState(() {});
      }
    }

  }

  Future<void> searchByCategory(String category) async {
    isLoading = false;
    list = [];
    setState(() {});
    String? result = await NetworkService.getDate(
        api: "${NetworkService.apiSearchCategory}/$category",
        param: NetworkService.paramEmpty());
    if (result != null) {
      allProductModel = allProductModelFromJson(result);
      list = allProductModel!.products!;
      isLoading = true;
      setState(() {});
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<String> categoriesList = [
    "smartphones",
    "laptops",
    "fragrances",
    "skincare",
    "groceries",
    "home-decoration",
    "furniture",
    "tops",
    "womens-dresses",
    "womens-shoes",
    "mens-shirts",
    "mens-shoes",
    "mens-watches",
    "womens-watches",
    "womens-bags",
    "womens-jewellery",
    "sunglasses",
    "automotive",
    "motorcycle",
    "lighting"
  ];

  @override
  Widget build(BuildContext context) {
    var userInfo = ModalRoute.of(context)?.settings.arguments;
    if(userInfo is UsersModel && userInfo != null){
      return Scaffold(
        appBar: AppBar(
          title: const Text("A.I Home Page"),
          centerTitle: true,
          leading: Builder(
              builder: (context) {
                return IconButton(onPressed: (){
                  Scaffold.of(context).openDrawer();
                }, icon: const Icon(Icons.category));
              }
          ),
          actions: [
            Builder(
                builder: (context) {
                  return IconButton(onPressed: (){
                    Scaffold.of(context).openEndDrawer();
                  }, icon: const Icon(Icons.person));
                }
            )
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: [
              const SizedBox(height: 20,),
              const Text("Categories",style: TextStyle(color: Colors.black,fontSize: 26,fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
              Expanded(
                child: ListView.builder(itemBuilder: (context, index) => Card(
                  color: Colors.blueGrey,
                  child: ListTile(
                    onTap: (){
                      searchByCategory(categoriesList[index]);
                    },
                    title: Text(categoriesList[index]),
                  ),
                ),
                  itemCount: categoriesList.length,
                ),
              ),
            ],
          ),
        ),
        endDrawer: Drawer(
          child: Column(
            children: [
              const SizedBox(height: 35,),
              CircleAvatar(
                radius: 60,
                child: Image.network(userInfo.image,fit: BoxFit.cover,),
              ),
              const SizedBox(height: 20,),
              Text("fist name: ${userInfo.firstName}",style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
              const SizedBox(height: 20,),
              Text("last name: ${userInfo.lastName}",style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
              const SizedBox(height: 20,),
              Text("email: ${userInfo.email}",style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
              const SizedBox(height: 20,),
              Text("gender: ${userInfo.gender}",style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),
              const SizedBox(height: 20,),
              Text("id: ${userInfo.id}",style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 20),),

            ],
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: controller,
                  onChanged: (text) async {
                    await searchProducts(text);
                    setState(() {}
                    );
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      suffixIcon: IconButton(onPressed: (){}, icon: const Icon(Icons.search_outlined),)
                  ),
                ),
              ),
            ),
            Expanded(
                child: isLoading ? ListView.builder(
                  itemBuilder: (context, index) {
                    var product = list[index];
                    return Card(
                      child: ListTile(
                        title: Text(product.title ?? "No title"),
                        trailing: Text("id: ${product.id.toString()}" ?? "no id"),
                        leading: Image.network(product.images?[0] ?? ""),
                      ),
                    );
                  },
                  itemCount: list.length,
                )
                    : const Center(child:  CircularProgressIndicator(),)
            )
          ],
        ),
      );
    }else{
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

  }
}
