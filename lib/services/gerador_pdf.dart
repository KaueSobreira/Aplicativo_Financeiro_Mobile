import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/despesa.dart';

class GeradorPdf {
  static Future<void> gerarRelatorio(List<Despesa> despesas) async {
    final pdf = pw.Document();
    
    final formatadorMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    
    double total = despesas.fold(0, (sum, item) => sum + item.valor);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        
        header: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Relatório de Despesas',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'Gerado em: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
              ),
              pw.SizedBox(height: 20),
            ],
          );
        },
        
        build: (context) {
          return [
            pw.TableHelper.fromTextArray(
              headers: ['Data', 'Descrição', 'Categoria', 'Valor'],
              data: despesas.map((d) => [
                d.dataVencimento,
                d.descricao,
                d.categoria,
                formatadorMoeda.format(d.valor),
              ]).toList(),
              
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.blue),
              rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300))),
              cellAlignment: pw.Alignment.centerLeft,
              cellAlignments: {3: pw.Alignment.centerRight},
            ),
            
            pw.SizedBox(height: 20),
            
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  'TOTAL: ${formatadorMoeda.format(total)}',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.red),
                ),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}