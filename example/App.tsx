import * as ImagePicker from 'expo-image-picker';
import { useState } from 'react';
import { StyleSheet, Image, View, Button } from 'react-native';
import { LiveTextView } from 'react-native-live-text-view';

export default function App() {
  const [image, setImage] = useState<string | null>(null);
  const [disabled, setDisabled] = useState(false);
  const [liveActionButtonHidden, setLiveActionButtonHidden] = useState(false);

  const pickImage = async () => {
    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.All,
      allowsEditing: true,
      quality: 1,
    });

    if (result.canceled) return;

    setImage(result.assets[0].uri);
  };

  return (
    <View style={styles.container}>
      <Button title="Pick an image" onPress={pickImage} />
      {image && (
        <>
          <Button title="toggleLiveTextDisabled" onPress={() => setDisabled(v => !v)} />
          <Button
            title="toggleLiveActionButtonHidden"
            onPress={() => setLiveActionButtonHidden(v => !v)}
          />
          <LiveTextView
            disabled={disabled}
            liveActionButtonHidden={liveActionButtonHidden}
            onStart={() => console.log('Image analyze start')}
            onReady={event => console.log(`Image analyze result: ${JSON.stringify(event)}`)}
            onError={event => console.log(`Image analyze error: ${event.error}`)}
            onHighlightChange={isHighlight => console.log(`isHighlight: ${isHighlight}`)}
            onTextSelectionChange={event =>
              console.log(
                `hasActiveTextSelection: ${event.hasActiveTextSelection}`,
                `selectedText: ${event.selectedText}`,
              )
            }
          >
            <Image source={{ uri: image }} style={styles.image} />
          </LiveTextView>
        </>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
  image: {
    width: 300,
    height: 300,
  },
});
