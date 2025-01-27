import 'package:a3_udwmj/controller/db_sqlite.dart';
import 'package:a3_udwmj/view/tarefas/dashbord.dart';
import 'package:a3_udwmj/view/tarefas/edit_task.dart';
import 'package:a3_udwmj/view/usuarios/login.dart';
import 'package:flutter/material.dart';

class idTask_Pub {
  static int idTsk = 0;
}

//static int idTask_Pub = 0;



class Task extends StatelessWidget {
  const Task({super.key});

  
  //const Task({super.key});
  
  // final String itemm;

  //int idTask;
// Task({Key? key, required this.itemm, required this.idTask}) : super(key: key);
  //Task({Key? key, required this.itemm, required this.idTask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // idTask_Pub.idTsk = idTask;

    //db_sqlite sqfliteInst = db_sqlite();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          leading: Padding(
            padding: const EdgeInsets.all(8.0), // Adiciona margem à imagem
            child: Image.asset(
              'assets/Taskify.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(0.0),
          child: MyTask(),
        ),
      ),
    );
  }
}

class MyTask extends StatefulWidget {
  const MyTask({super.key});

  @override
  State<MyTask> createState() => _MyFormState();
}

class _MyFormState extends State<MyTask> {
  final TextEditingController dtInicio = TextEditingController();
  final TextEditingController dtFim = TextEditingController();
  final TextEditingController titulo = TextEditingController();
  final TextEditingController descricao = TextEditingController();
  //final TextEditingController categoria = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTask();
  }

  Future<void> loadTask() async {
    Map<String, Object?> dados = await getTask(idTask_Pub.idTsk);
    setState(() {
      titulo.text = dados['titulo']!.toString();
      descricao.text = dados['descricao']!.toString();
      dtInicio.text = dados['data_inicial']!.toString();
      dtFim.text = dados['data_final']!.toString();
      DropdownUtils.StatusDropdownValue = dados['status']!.toString();
      DropdownUtils.CategoriaDropdownValue = dados['categoria']!.toString();
     

     //print("DropdownUtils.StatusDropdownValue");
     //print(DropdownUtils.StatusDropdownValue);
      //_DropdownFieldState.categoria = dados['categoria']!.toString();
      //categoria.text = dados['categoria']!.toString();
    });
  }

  Future<Map<String, Object?>> getTask(int id) async {
    db_sqlite sqfliteInst = db_sqlite();
    return await sqfliteInst.getTaskByIdTask(idTask_Pub.idTsk);
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text =
            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    db_sqlite sqfliteInst = db_sqlite();
   
    

   // static var StatusDropdownValue;

   // var CategoriaDropdownValue;

    var value;
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  
                   print("StatusDropdownValue");
                //  print(DropdownUtils.StatusDropdownValue.toString());

                  print("CategoriaDropdownValue");
                 // print(DropdownUtils.CategoriaDropdownValue.toString());
                  
                  
                 if (titulo.text != "" &&
                    (descricao.text != "")) {
                      sqfliteInst.updateTask(
                      idTask_Pub.idTsk,
                      user_Pub.userOn,
                      titulo.text,
                      descricao.text,
                      dtInicio.text,
                      dtFim.text,
                      DropdownUtils.CategoriaDropdownValue.toString(),
                      DropdownUtils.StatusDropdownValue.toString());
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );
                }
                 
                },
                child: const Text(
                  "Voltar",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Positioned(
              bottom: 0, // Distância da parte inferior
              right: 0, // Distância da parte direita
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditTask()),
                  );
                },
                child: const Icon(Icons.edit),
              ),
            ),
            Positioned(
              bottom: 0, // Distância da parte inferior
              right: 0, // Distância da parte direita
              child: FloatingActionButton(
                onPressed: () {
                  sqfliteInst.deleteTask(idTask_Pub.idTsk);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );
                },
                child: const Icon(Icons.delete_forever),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextField(
          // enabled: false,
          readOnly: true,
          controller: titulo,
          maxLines: 1,
          decoration: const InputDecoration(
            labelText: 'Título',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: 
                
               DropdownUtils.StatusDropdown(
              value: DropdownUtils.StatusDropdownValue, //"Atrasado"
              onChanged: (newValue) {
                setState(() {
                  DropdownUtils.StatusDropdownValue = newValue;
                   // newValue;
                   print("Status");
                   print(newValue);
                   print("value");
                   print(value);
                 // print(DropdownUtils.StatusDropdownValue);

                });
              },
            ), 


            ),    
            SizedBox(width: 20),
            Expanded(
              child:
                
                     DropdownUtils.CategoriaDropdown(
              value: DropdownUtils.CategoriaDropdownValue,//"Tarefa"
              onChanged: (newValue) {
                setState(() {
                  DropdownUtils.CategoriaDropdownValue = newValue;
                 // newValue;
                  print("Categoria");
                  print(DropdownUtils.CategoriaDropdownValue.toString());
                 // value = newValue;
                });
              },
            ), 


            ),
                      
          ],
        ),

        const SizedBox(height: 20),
        TextField(
          // enabled: false,
          readOnly: true,
          controller: descricao,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Descrição',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        Row( // Data Inicio e Fim
          children: [
            Expanded(
              child: TextField(
                //  enabled: false,

                controller: dtInicio,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Data Início*',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, dtInicio),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                //  enabled: false,
                controller: dtFim,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Data Fim*',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, dtFim),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),        
               
        const SizedBox(height: 50),
        RodapeApk(context),
      ],
    )
    );
  }
}


class DropdownUtils {
  
  static String? StatusDropdownValue, CategoriaDropdownValue;

  static Widget StatusDropdown({
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
   // value = StatusDropdownValue;
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(),
      ),
      value: value,
      onChanged: onChanged,
      items: <String>['Em Progresso', 'Aguardando', 'Atrasado', 'Concluido']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  static Widget CategoriaDropdown({
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
  //  value = CategoriaDropdownValue;
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Categoria',
        border: OutlineInputBorder(),
      ),
      value: value,
      onChanged: onChanged,
      items: <String>['Tarefa', 'Lembrete']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

/*
class DropdownField extends StatefulWidget {
  const DropdownField({super.key});

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  static String? categoria;

  // Lista de opções
  final List<String> options = [
    'Tarefa',
    'Evento',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Categoria',
        border: OutlineInputBorder(),
      ),
      value: categoria,
      
      isExpanded: true,
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          categoria = newValue;
        });
      },
    );
  }
}

*/