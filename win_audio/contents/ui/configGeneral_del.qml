import QtQuick 2.0
import QtQuick.Controls 2.5 as QQC2
import org.kde.kirigami 2.4 as Kirigami

Kirigami.FormLayout {
	id: page

	// property alias cfg_WinOpenSound: labelText.text

	QQC2.TextField {
		id: WinOpenSound
		Kirigami.FormData.label: i18n("Label:")
		placeholderText: i18n("Placeholder")
	}
}
